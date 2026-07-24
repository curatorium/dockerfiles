# shellcheck shell=bash
# shellcheck disable=SC2016  # probe snippets are expanded inside the container, not on the host

# Shared probe mechanics for the per-role image suites. Each suite sources this,
# picks its role, and asserts only that role's own increment over its parent.
# The image under test is $IMAGE — a digest passed by CI, or the host-arch local
# image resolved from .env by img_for.

: "${IMAGE:=}"

_host_arch() {
	case "$(uname -m)" in
		x86_64)        echo amd64 ;;
		aarch64|arm64) echo arm64 ;;
		*)             uname -m ;;
	esac
}

_env() {
	local root
	root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
	sed -n "s/^$1=//p" "$root/.env" 2>/dev/null | tail -1 | tr -d '[:space:]'
}

img_for() {
	local role="$1" ts arch phpvs
	ts=$(_env TS); arch=$(_host_arch); phpvs=$(_env PHPVS)
	case "$role" in
		base)     printf 'curatorium/base:%s-%s' "$ts" "$arch" ;;
		ci)       printf 'curatorium/ci:%s-%s' "$ts" "$arch" ;;
		az-ci)    printf 'curatorium/az-ci:%s-%s' "$ts" "$arch" ;;
		php-base) printf 'curatorium/php-%s:base-%s-%s' "$phpvs" "$ts" "$arch" ;;
		php-qa)   printf 'curatorium/php-%s:qa-%s-%s' "$phpvs" "$ts" "$arch" ;;
		php-fs)   printf 'curatorium/php-%s:fs-%s-%s' "$phpvs" "$ts" "$arch" ;;
	esac
}

# Run a snippet inside the image with the entrypoint bypassed — probes must never
# start the serving entrypoint.
_sh() { docker run --rm --entrypoint sh "$IMAGE" -c "$1" >/dev/null 2>&1; }

on_path() { _sh 'p=$(command -v '"$1"') && [ -s "$p" ] && [ -x "$p" ]'; }

# Executes without the shell's cannot-exec / not-found codes (126/127); any other
# exit still counts as "runs". Guarded by timeout so a bare tool cannot hang.
runs() {
	docker run --rm --entrypoint sh "$IMAGE" -c \
		'timeout 10 '"$1"' --version >/dev/null 2>&1; rc=$?; [ "$rc" -ne 126 ] && [ "$rc" -ne 127 ]' \
		>/dev/null 2>&1
}

has_ext() { _sh 'php -r "exit(extension_loaded(\"'"$1"'\")?0:1);"'; }

has_file() { _sh '[ -e "'"$1"'" ]'; }

emits() { docker run --rm --entrypoint sh "$IMAGE" -c "$1" 2>/dev/null | grep -q -- "$2"; }

# Major.minor of the php in the image (empty when php is absent).
php_version() {
	docker run --rm --entrypoint sh "$IMAGE" -c \
		'php -r "echo PHP_MAJOR_VERSION.\".\".PHP_MINOR_VERSION;"' 2>/dev/null
}

# Boots the real entrypoint and asserts nginx+php-fpm serve a php sentinel from
# /app. Seeds and probes from inside the container (docker-out-of-docker safe).
serves() {
	local cid body _
	cid=$(docker run -d "$IMAGE" 2>/dev/null) || return 1
	docker exec -u root "$cid" sh -c \
		'mkdir -p /app/public && printf "<?php echo \"SENTINEL-OK\";" > /app/public/index.php' 2>/dev/null
	body=""
	for _ in $(seq 1 20); do
		body=$(docker exec "$cid" sh -c \
			'curl -fsS http://localhost/ 2>/dev/null || php -r "echo @file_get_contents(\"http://localhost/\");"' 2>/dev/null) \
			&& [ -n "$body" ] && break
		sleep 1
	done
	docker rm -f "$cid" >/dev/null 2>&1
	case "$body" in *SENTINEL-OK*) return 0 ;; *) return 1 ;; esac
}

# Batched gate probes — one container each, printing the offenders (empty = all good).
all_on_path() {
	docker run --rm --entrypoint sh "$IMAGE" -c \
		'for b in '"$*"'; do command -v "$b" >/dev/null 2>&1 || printf "%s " "$b"; done' 2>/dev/null
}
all_runs() {
	docker run --rm --entrypoint sh "$IMAGE" -c \
		'for b in '"$*"'; do timeout 10 "$b" --version >/dev/null 2>&1; rc=$?; { [ "$rc" = 126 ] || [ "$rc" = 127 ]; } && printf "%s " "$b"; done' 2>/dev/null
}
all_exts() {
	docker run --rm --entrypoint sh "$IMAGE" -c \
		'for e in '"$*"'; do php -r "exit(extension_loaded(\"$e\")?0:1);" 2>/dev/null || printf "%s " "$e"; done' 2>/dev/null
}

mark() { if "$@"; then printf '✅'; else printf '❌'; fi; }

# Markdown rows for a binary list: On PATH + Runs columns.
bin_rows() {
	local b
	for b in "$@"; do
		printf '| `%s` | %s | %s |\n' "$b" "$(mark on_path "$b")" "$(mark runs "$b")"
	done
}

# Markdown rows for a presence-only list (scripts, helpers): On PATH column.
path_rows() {
	local b
	for b in "$@"; do
		printf '| `%s` | %s |\n' "$b" "$(mark on_path "$b")"
	done
}

# Markdown rows for a php extension list: Loaded column.
ext_rows() {
	local e
	for e in "$@"; do
		printf '| `%s` | %s |\n' "$e" "$(mark has_ext "$e")"
	done
}
