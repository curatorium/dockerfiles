# php-qa — curatorium/php-8.3:qa-latest-amd64

## QA extensions

| Extension | State |
|-----------|-------|
| `pcov` (available, disabled)   | ✅ |
| `xdebug` (available, disabled) | ✅ |
| `phpdbg` (on PATH · runs)      | ✅ · ✅ |

## Security scanners (On PATH · Runs)

| Binary | On PATH | Runs |
|--------|---------|------|
| `snyk` | ✅ | ✅ |
| `gitleaks` | ✅ | ✅ |
| `local-php-security-checker` | ✅ | ✅ |

## Composer tools → /usr/local/bin (On PATH · Runs)

| Binary | On PATH | Runs |
|--------|---------|------|
| `phpstan` | ✅ | ✅ |
| `psalm` | ✅ | ✅ |
| `phpunit` | ✅ | ✅ |
| `php-cs-fixer` | ✅ | ✅ |
| `infection` | ✅ | ✅ |
| `phpinsights` | ✅ | ✅ |
| `phpmnd` | ✅ | ✅ |
| `phplint` | ✅ | ✅ |
| `phpdcd` | ✅ | ✅ |
| `psysh` | ✅ | ✅ |
| `composer-require-checker` | ✅ | ✅ |
| `composer-unused` | ✅ | ✅ |
| `codecept` | ✅ | ✅ |
| `var-dump-server` | ✅ | ✅ |
| `ez-cfg` | ✅ | ✅ |

## Gate

| Check | Result |
|-------|--------|
| pcov/xdebug available, phpdbg present | ✅ |
| scanners on PATH                      | ✅ |
| composer tools on PATH                | ✅ |
| composer tools run                    | ✅ |

## Summary

| ✅ Pass | ❌ Fail | ⚠️ Error |
|---------|---------|----------|
| 4 | 0 | 0 |

