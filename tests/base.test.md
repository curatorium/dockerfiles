# base — curatorium/base:latest-amd64

## Essentials + fetched tools (On PATH · Runs)

| Binary | On PATH | Runs |
|--------|---------|------|
| `cron` | ✅ | ✅ |
| `gpg` | ✅ | ✅ |
| `jq` | ✅ | ✅ |
| `less` | ✅ | ✅ |
| `nano` | ✅ | ✅ |
| `patch` | ✅ | ✅ |
| `sudo` | ✅ | ✅ |
| `tini` | ✅ | ✅ |
| `unzip` | ✅ | ✅ |
| `steward` | ✅ | ✅ |
| `bash-test` | ✅ | ✅ |

## Helpers + runtime scripts (On PATH)

| Binary | On PATH |
|--------|---------|
| `bash-import` | ✅ |
| `wait-until` | ✅ |
| `entrypoint` | ✅ |
| `service` | ✅ |
| `clean-tmp` | ✅ |
| `daemonize` | ✅ |
| `healthcheck` | ✅ |
| `envsubst-only-prefix` | ✅ |

## Data

| Check | Result |
|-------|--------|
| tzdata (`/usr/share/zoneinfo/UTC`) | ✅ |

## Gate

| Check | Result |
|-------|--------|
| all binaries on PATH | ✅ |
| all binaries run     | ✅ |
| tzdata present       | ✅ |

## Summary

| ✅ Pass | ❌ Fail | ⚠️ Error |
|---------|---------|----------|
| 3 | 0 | 0 |

