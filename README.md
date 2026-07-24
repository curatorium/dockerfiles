Curatorium PHP Dockerfiles
======================================================================

## About

This repository contains the Dockerfiles used to build the multi-arch (AMD64 +
ARM64) images found at https://hub.docker.com/u/curatorium, for PHP 8.0
through 8.5 (the older `neurony/php-$PHPVS` images remain, frozen).

They aim to:
- be compatible with [Symfony](http://symfony.com/) & [Laravel](https://laravel.com/) basic requirements
- support commonly used extensions (`gd`, `mysql`, `redis`, etc.)
- be useful in ci/cd pipelines to run tests and quality gates
- include useful PHP tools (`composer`, `phpunit`, `phpstan`, etc.)

PHP packages come from the [deb.sury.org](https://deb.sury.org/) repository
(the Debian counterpart of the `ondrej/php` PPA). Images are built and
published by GitHub Actions on native per-architecture runners.

## Image naming convention

Six roles in two lineages off `base`:

```
base (debian:bookworm-slim)
 ├── ci  ── az-ci                    (PHP-free tooling)
 └── php-base ── php-qa ── php-fs    (PHP + nginx)
```

PHP-free roles publish without a PHP version; PHP roles carry it in the repo:

```
  curatorium/<role>:<version>[-<arch>]              role = base|ci|az-ci
  curatorium/php-<PHPVS>:<role>-<version>[-<arch>]  role = base|qa|fs, PHPVS = 8.0 ... 8.5
```

- Version: a `YY.MM` timestamp or `latest`
- Per-arch tags carry an `-amd64` / `-arm64` suffix; the bare tag is a manifest combining both

## Usage
As a server:
  ```bash
  docker run -v "$PWD:/app" curatorium/php-8.5:base # will start nginx + php-fpm (+ crond + var-dump; if enabled)
  ```
  or
  ```yaml
  # docker-compose.yml
  services:
    backend:
      image: curatorium/php-8.5:base
      ports:
        - 80:80     # served by NGINX by default
  ```

As a command runner:
  ```bash
  docker run -v "$PWD:/app" curatorium/php-8.5:base php /app/command.php # will execute your command & exit
  ```

As a pipeline runner:
  ```yaml
  # .github/workflows/ci.yml
  jobs:
    qa:
      runs-on: ubuntu-latest
      container: curatorium/php-8.5:qa
      steps:
        - uses: actions/checkout@v4
        - run: phpstan
  ```

## Repositories

Each role owns a directory (`<role>/Dockerfile` + `<role>/Stewardfile` +
`<role>/files/`). `./generate-dockerfile` concatenates the per-role Dockerfiles
into the root multi-stage `Dockerfile`, so each role is a build target and a
published tag.


### Base image `curatorium/base:$VERSION`
ex.: `curatorium/base` or `curatorium/base-26.07` or `curatorium/base-26.07-amd64`

Built on `debian:bookworm-slim` -- the OS foundation shared by every role. No
PHP, no nginx (those start at `php-base`). Tools:

- `tini` (PID 1 / init)
- `cron`
- `wait-until`
- `bash-import`, `bash-test`, `steward`
- the runtime scripts: `entrypoint`, `service`, `daemonize`, `healthcheck`, `clean-tmp`, `envsubst-only-prefix`, `add-debug`, `add-forensics`
- `jq`, `gnupg`, `nano`, `less`, `patch`, `sudo`, `unzip`, `locales`, `tzdata`

Services are managed by the `service` script (init.d + `start-stop-daemon`, no
systemd). `$ENABLED_SERVICES` is empty here and defaults to `"php-fpm nginx"` in
`php-base`.


### CI image `curatorium/ci:$VERSION`
ex.: `curatorium/ci` or `curatorium/ci-26.07` or `curatorium/ci-26.07-amd64`

Extends the base image with PHP-free CLI tooling for pipelines -- preparing
deployments, rendering configuration, building images:

- `docker` (CLI + `compose` plugin + `buildx` plugin)
- `kubectl`, `kubelogin`, `kubectl-krew` (+ plugins: `grep`, `exec-cronjob`, `krew`, `slice`, `split-yaml`, `sort-manifests`)
- `node`, `npm`, `yarn`
- `ejson`, `ez-cfg` (easy-config), `skeema`, `yq`, `pup`, `gron`, `http` (HTTPie)
- `q` -- AMD64 only (upstream ships no ARM64 package)
- `newrelic-cli`
- `git`, `openssh-client`
- `mariadb-client`, `redis-tools`, `libmemcached-tools`
- `7zip`, `bzip2`, `tar`, `xz-utils`, `zip`, `unzip`


### Azure CI image `curatorium/az-ci:$VERSION`
ex.: `curatorium/az-ci` or `curatorium/az-ci-26.07` or `curatorium/az-ci-26.07-amd64`

Extends the CI image with `az` (Azure CLI).


### PHP base image `curatorium/php-$PHPVS:base-$VERSION`
ex.: `curatorium/php-8.5:base` or `curatorium/php-8.5:base-26.07` or `curatorium/php-8.5:base-26.07-amd64`

Extends the base image with PHP + nginx. PHP extensions:

- `amqp`, `apcu`, `bcmath`, `curl`, `gd`, `http`, `igbinary`, `imagick`,
  `intl`, `mbstring`, `mongodb`, `msgpack`, `mysql`, `odbc`, `pgsql`,
  `protobuf`, `raphf`, `readline`, `redis`, `soap`, `sqlite3`, `ssh2`,
  `stomp`, `xml`, `xsl`, `yaml`, `zip`
- `timezonedb` -- via pecl
- `grpc`, `memcached`, `opcache`, `zmq` -- best-effort; skipped where sury has no package (e.g. 8.5)
- `newrelic` -- AMD64 only, disabled unless `$NEWRELIC_ENABLED` is set

Tools:

- `composer`
- `nginx` (apt + `gettext-base` for envsubst)
- `php-fpm`
- image optimisers: `ghostscript`, `imagemagick`, `jpegoptim`, `optipng`, `pngquant`, `gifsicle`

`$ENABLED_SERVICES` defaults to `"php-fpm nginx"` here and to `""` in
`php-qa`/`php-fs`; `var-dump` is available but off by default.


### PHP QA image `curatorium/php-$PHPVS:qa-$VERSION`
ex.: `curatorium/php-8.5:qa` or `curatorium/php-8.5:qa-26.07` or `curatorium/php-8.5:qa-26.07-amd64`

Extends the php-base image with PHP extensions:

- `pcov` -- installed, disabled by default
- `xdebug` -- installed, disabled by default
- `phpdbg`

Security scanners:

- `gitleaks` -- secret scanner
- `snyk`
- `local-php-security-checker`

...and PHP tools, each installed into its own `/opt/<tool>/`:

- `codecept` (codeception)
- `composer-require-checker`
- `composer-unused`
- `easy-config`
- `infection`
- `php-cs-fixer`
- `phpdcd`
- `phpinsights`
- `phplint`
- `phpmnd`
- `phpstan` + `phpat`, `ekino/phpstan-banned-code`, `larastan`, `phpstan-symfony`, `phpstan-doctrine`, `phpstan-dba`, `phpstan-deprecation-rules`, `phpstan-beberlei-assert`, `phpstan-todo-by`, `shipmonk/dead-code-detector`
- `phpunit` + `paratest`
- `psalm` + `plugin-laravel`, `plugin-symfony`, `doctrine-psalm-plugin`
- `psysh` -- a much improved PHP interactive shell (+ `laravel/tinker`, `psysh-bundle`)
- `var-dumper`
- `git`, `openssh-client`


### PHP FS image `curatorium/php-$PHPVS:fs-$VERSION`
ex.: `curatorium/php-8.5:fs` or `curatorium/php-8.5:fs-26.07` or `curatorium/php-8.5:fs-26.07-amd64`

Extends the php-qa image with `nodejs`, `npm`, `npx`, `yarn`, and front-end
framework CLIs:

- `@angular/cli`
- `@vue/cli`
- `react-cli`
- `@ionic/cli`
- `@symfony/webpack-encore`
- `laravel-mix`
- `grunt-cli`

----------------------------------------------------------------------

## Build

Installers are steward `Stewardfile`s (primitives `apt`/`key`/`src`/`deb`/`bin`/
`tar`/`zip`/`ext`/`npm`/`composer`, `defer` for the rest) -- one per role. Steward
is `ADD`ed in `base/Dockerfile` (bootstrap), then runs each role's Stewardfile.

The root `Dockerfile` is GENERATED from the per-role `<role>/Dockerfile` files by
`./generate-dockerfile`; edit the per-role files, then regenerate. Set your
environment (`.env.sample` is the template), regenerate, and build:

```bash
  git clone git@github.com:curatorium/php-dockerfiles.git;
  cd php-dockerfiles/;

  cp .env.sample .env
  nano .env # specify a PHP version ($PHPVS), a Node version ($NODEVS), a tag timestamp ($TS)

  ./generate-dockerfile                        # regenerate the root Dockerfile
  export X_ARCH=$(dpkg --print-architecture)   # part of the image tag; not in .env.sample
  docker compose build

  # or a specific PHP version, Node version and timestamp
  PHPVS=8.5 NODEVS=25 TS=`date +%y.%m` X_ARCH=amd64 docker compose build

  # or a single role
  docker compose build php-qa
```

Build args: `PHPVS` (8.0-8.5), `NODEVS` (Node major), `TS` (`YY.MM` or
`latest`), `X_ARCH` (`amd64`/`arm64`). `docker-compose.override.yml` mounts the
per-role `files/` and `tests/` into the containers, so they can be edited without
rebuilding.

## Tests

[`bash-test`](https://github.com/curatorium/bash-test) suites under `tests/`,
run against built images -- one per role:

- `tests/service.test` -- service manager + entrypoint behaviour; re-execs itself INSIDE the base image
- `tests/<role>.test` (`base`/`ci`/`az-ci`/`php-base`/`php-qa`/`php-fs`) -- each probes only that role's increment over its parent (binaries on PATH + Runs, PHP extensions loaded; `php-base` also checks PHP version + nginx serving). The image under test is `$IMAGE` (a digest in CI, or the host-arch image from `.env` locally)

Reports are committed under `tests/*.test[.$PHPVS].md`. `.githooks/pre-commit`
regenerates them from the locally built images (the `PHPVS` in `.env`) and fails
the commit if a report is stale or a suite fails.

## CI / publishing

`.github/workflows/build.yml` -- manual `workflow_dispatch` (with a selectable PHP-version subset):

- two families off the generated `Dockerfile`: infra (`base`/`ci`/`az-ci`, no PHP axis) → `curatorium/<role>`, and PHP (`base`/`qa`/`fs` × PHPVS) → `curatorium/php-<PHPVS>:<role>`
- each job builds its stage on native `amd64`/`arm64` runners (no qemu), runs that role's `tests/<role>.test` against the pushed digest, and pushes by digest with build provenance + an SBOM attestation
- a merge job joins `-amd64` + `-arm64` with `docker buildx imagetools` into `:role-$TS` and the rolling `:role`, then attests the merged index

## Security scanning

A GitHub Actions workflow runs [Docker Scout](https://docs.docker.com/scout/)
against the published images and uploads the results to the repository's
**Security → Code scanning** tab. Scout analysis is free, and as an MIT-licensed
open-source project this repository is eligible for the
[Docker-Sponsored Open Source](https://www.docker.com/community/open-source/application/)
program, which grants unlimited Scout analysis and removes image pull rate limits
for everyone pulling these images.

Each `qa` image also carries `gitleaks` for secret scanning and
`local-php-security-checker` for auditing a project's Composer dependencies.

### Contributing

Pull requests welcome
