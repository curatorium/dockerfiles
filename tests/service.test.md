# Service & Entrypoint tests

## Service lifecycle

| Behaviour | Result |
|-----------|--------|
| not-installed → status 9              | ✅ |
| after install → status 3              | ✅ |
| after start → status 0, stub ran      | ✅ |
| after stop → status 3                 | ✅ |
| after uninstall → status 9            | ✅ |
| start already-running → 1             | ✅ |
| stop already-stopped → 1              | ✅ |
| restart re-runs command (+1 line)     | ✅ |
| literal '*' arg passed, not globbed   | ✅ |

## Monitor

| Behaviour | Result |
|-----------|--------|
| monitor starts enabled service        | ✅ |
| monitor restarts killed service       | ✅ |
| monitor does NOT restart disabled svc | ✅ |

## Entrypoint wiring

| Behaviour | Result |
|-----------|--------|
| .sh scripts execute                   | ✅ |
| .envsh scripts sourced into env       | ✅ |
| one-shot command runs and exits       | ✅ |
| ENABLED_SERVICES fed to monitor       | ✅ |

## Summary

| ✅ Pass | ❌ Fail | ⚠️ Error |
|---------|---------|----------|
| 16 | 0 | 0 |

