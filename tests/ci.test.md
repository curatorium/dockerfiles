# ci — curatorium/ci:latest-amd64

## Binaries (On PATH · Runs)

| Binary | On PATH | Runs |
|--------|---------|------|
| `docker` | ✅ | ✅ |
| `kubectl` | ✅ | ✅ |
| `kubectl-krew` | ✅ | ✅ |
| `yq` | ✅ | ✅ |
| `ejson` | ✅ | ✅ |
| `skeema` | ✅ | ✅ |
| `pup` | ✅ | ✅ |
| `gron` | ✅ | ✅ |
| `http` | ✅ | ✅ |
| `mariadb` | ✅ | ✅ |
| `redis-cli` | ✅ | ✅ |
| `node` | ✅ | ✅ |
| `yarn` | ✅ | ✅ |
| `newrelic` | ✅ | ✅ |
| `7zz` | ✅ | ✅ |
| `bzip2` | ✅ | ✅ |
| `xz` | ✅ | ✅ |
| `zip` | ✅ | ✅ |
| `git` | ✅ | ✅ |
| `ssh` | ✅ | ✅ |
| `memcstat` | ✅ | ✅ |
| `html2markdown` | ✅ | ✅ |

## Docker plugins · amd64-only · shared libs

| Check | Result |
|-------|--------|
| `docker compose` runs | ✅ |
| `docker buildx` runs  | ✅ |
| `q` on PATH (amd64)   | ✅ |
| libfcgi shared lib      | ✅ |

## kubectl-krew plugins

| Plugin | Installed |
|--------|-----------|
| `grep` | ✅ |
| `exec-cronjob` | ✅ |
| `krew` | ✅ |
| `slice` | ✅ |
| `split-yaml` | ✅ |
| `sort-manifests` | ✅ |

## Gate

| Check | Result |
|-------|--------|
| all binaries on PATH  | ✅ |
| all binaries run      | ✅ |
| docker plugins run    | ✅ |
| libfcgi present       | ✅ |
| krew plugins present  | ✅ |
| amd64-only tools      | ✅ |

## Summary

| ✅ Pass | ❌ Fail | ⚠️ Error |
|---------|---------|----------|
| 6 | 0 | 0 |

