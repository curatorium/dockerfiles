# shellcheck shell=bash
# shellcheck disable=SC2016  # the sh -c snippets expand inside the container, not here
# Shared probes for the per-role image tests. Each tests/<role>.test owns its own
# check list; this file only provides the mechanics to probe an image.

# On PATH: the name resolves via command -v and the file is readable, non-empty
# and executable — i.e. it's installed and linked into PATH.
on_path() { docker run --rm --entrypoint sh "$1" -c 'p=$(command -v '"$2"') && [ -r "$p" ] && [ -s "$p" ] && [ -x "$p" ]' >/dev/null 2>&1; }

# Runs: actually execute the binary (its --version) and assert the OS could invoke
# it — exit is anything EXCEPT 126 (found but not executable: wrong arch, missing
# .so, bad shebang) or 127 (not found). A wrong --version flag still proves the
# binary ran, so this needs no per-tool flag table; timeout caps tools that block.
runs() { docker run --rm --entrypoint sh "$1" -c 'timeout 5 '"$2"' --version </dev/null >/dev/null 2>&1; s=$?; [ "$s" != 126 ] && [ "$s" != 127 ]' >/dev/null 2>&1; }

# Loaded: the php extension is loaded at runtime.
has_ext() { docker run --rm --entrypoint sh "$1" -c 'php -r "exit(extension_loaded(\"'"$2"'\")?0:1);"' >/dev/null 2>&1; }

# Local default when IMAGE isn't passed (CI passes the per-arch digest): the
# host-arch image for this role at the PHPVS/TS from .env.
img_for() { printf 'curatorium/php-%s:%s-%s-%s' "${PHPVS:?}" "$1" "${TS:?}" "${X_ARCH:?}"; }

# base: php reports the expected version.
php_version() {
  local v; v=$(docker run --rm --entrypoint sh "$1" -c 'php -v' 2>/dev/null)
  assert:contains "$v" "PHP $PHPVS" "wrong php version"
}

# base: the real entrypoint serves php on :80. Seed + probe from inside the
# container (docker exec), not a host bind-mount + port — those resolve on the
# daemon host and break when the harness runs inside the ci image (docker-out-of-docker).
serves() {
  local cid body _
  cid=$(docker run -d "$1" 2>/dev/null) || { echo "docker run failed"; return 1; }
  docker exec -u root "$cid" sh -c 'mkdir -p /app/public && printf "<?php echo \"SENTINEL-OK\";" > /app/public/index.php' 2>/dev/null
  body=""
  for _ in $(seq 1 20); do
    body=$(docker exec "$cid" sh -c 'curl -fsS http://localhost/ 2>/dev/null || php -r "echo @file_get_contents(\"http://localhost/\");"' 2>/dev/null) \
      && [ -n "$body" ] && break
    sleep 1
  done
  docker rm -f "$cid" >/dev/null 2>&1
  assert:contains "$body" "SENTINEL-OK" "nginx did not serve the sentinel page"
}
