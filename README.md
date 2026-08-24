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
published tag. Each role's tool set is the live `<role>/Stewardfile`, embedded
below.


### Base image `curatorium/base:$VERSION`
ex.: `curatorium/base` or `curatorium/base-26.07` or `curatorium/base-26.07-amd64`

Built on `debian:bookworm-slim` -- the OS foundation shared by every role. No
PHP, no nginx (those start at `php-base`). Installed by its Stewardfile:

```bash
#!/usr/local/bin/steward

apt cron
apt gettext-base
apt gnupg
apt jq
apt less
apt locales
apt nano
apt patch
apt sudo
apt tini
apt tzdata
apt unzip

bin wait-until https://raw.githubusercontent.com/nickjj/wait-until/v0.3.0/wait-until
bin bash-import https://github.com/curatorium/bash-import/releases/download/v1.0.0-alpha.5/bash-import
bin bash-test https://github.com/curatorium/bash-import/releases/download/v1.0.0-alpha.5/bash-test
```

The runtime scripts (`entrypoint`, `service`, `daemonize`, `healthcheck`,
`clean-tmp`, `envsubst-only-prefix`, `add-debug`, `add-forensics`) are COPY'd
in from `base/files/`, not steward-installed.

Services are managed by the `service` script (init.d + `start-stop-daemon`, no
systemd). `$ENABLED_SERVICES` is empty here and defaults to `"php-fpm nginx"` in
`php-base`.


### CI image `curatorium/ci:$VERSION`
ex.: `curatorium/ci` or `curatorium/ci-26.07` or `curatorium/ci-26.07-amd64`

Extends the base image with PHP-free CLI tooling for pipelines -- preparing
deployments, rendering configuration, building images. Installed by its
Stewardfile:

```bash
#!/usr/local/bin/steward

apt 7zip
apt bzip2
apt git
apt gron
apt httpie
apt libfcgi0ldbl
apt libmemcached-tools
apt mariadb-client
apt openssh-client
apt python3-html2text
apt redis-tools
apt tar
apt unzip
apt xz-utils
apt zip

deb https://github.com/shopify/ejson/releases/download/v1.5.2/ejson_1.5.2_linux_$ARCH.deb
deb https://github.com/skeema/skeema/releases/download/v1.14.1/skeema_$ARCH.deb
on-amd64 deb https://github.com/harelba/q/releases/download/v3.1.6/q-text-as-data-3.1.6-1.x86_64.deb
bin yq https://github.com/mikefarah/yq/releases/download/v4.35.2/yq_linux_$ARCH
zip pup pup https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_$ARCH.zip
ext https://download.newrelic.com/install/newrelic-cli/scripts/install.sh bash

# docker
apt docker-ce-cli
apt docker-compose-plugin
apt docker-buildx-plugin

# kubernetes
KUBECTLVS=1.36.3
KUBELOGINVS=0.2.19
bin kubectl https://dl.k8s.io/release/v$KUBECTLVS/bin/linux/$ARCH/kubectl
zip kubelogin bin/linux_$ARCH/kubelogin https://github.com/Azure/kubelogin/releases/download/v$KUBELOGINVS/kubelogin-linux-$ARCH.zip
tar kubectl-krew krew-linux_$ARCH https://github.com/kubernetes-sigs/krew/releases/download/v0.5.0/krew-linux_$ARCH.tar.gz

# node
apt nodejs
npm yarn
```

### Azure CI image `curatorium/az-ci:$VERSION`
ex.: `curatorium/az-ci` or `curatorium/az-ci-26.07` or `curatorium/az-ci-26.07-amd64`

Extends the CI image with `az` (Azure CLI). Installed by its Stewardfile:

```bash
#!/usr/local/bin/steward

apt azure-cli
```

### PHP base image `curatorium/php-$PHPVS:base-$VERSION`
ex.: `curatorium/php-8.5:base` or `curatorium/php-8.5:base-26.07` or `curatorium/php-8.5:base-26.07-amd64`

Extends the base image with PHP + nginx. Installed by its Stewardfile:

```bash
#!/usr/local/bin/steward


apt php$PHPVS-amqp
apt php$PHPVS-apcu
apt php$PHPVS-bcmath
apt php$PHPVS-cli
apt php$PHPVS-common
apt php$PHPVS-curl
apt php$PHPVS-fpm
apt php$PHPVS-gd
apt php$PHPVS-http
apt php$PHPVS-igbinary
apt php$PHPVS-imagick
apt php$PHPVS-intl
apt php$PHPVS-mbstring
apt php$PHPVS-mongodb
apt php$PHPVS-msgpack
apt php$PHPVS-mysql
apt php$PHPVS-odbc
apt php$PHPVS-pgsql
apt php$PHPVS-protobuf
apt php$PHPVS-raphf
apt php$PHPVS-readline
apt php$PHPVS-redis
apt php$PHPVS-soap
apt php$PHPVS-sqlite3
apt php$PHPVS-ssh2
apt php$PHPVS-stomp
apt php$PHPVS-xml
apt php$PHPVS-xsl
apt php$PHPVS-yaml
apt php$PHPVS-zip

apt --try php$PHPVS-grpc
apt --try php$PHPVS-memcached
apt --try php$PHPVS-opcache
apt --try php$PHPVS-zmq

apt --temp make
apt --temp php$PHPVS-dev
apt --temp php-pear

ext https://getcomposer.org/installer php -- --version=2.10.2 --install-dir=/usr/local/bin --filename=composer

# newrelic
on-amd64 apt newrelic-php5

# image-optimisers
apt ghostscript
apt gifsicle
apt imagemagick
apt jpegoptim
apt optipng
apt pngquant

# nginx
apt nginx
```

`$ENABLED_SERVICES` defaults to `"php-fpm nginx"` here and to `""` in
`php-qa`/`php-fs`; `var-dump` is available but off by default.


### PHP QA image `curatorium/php-$PHPVS:qa-$VERSION`
ex.: `curatorium/php-8.5:qa` or `curatorium/php-8.5:qa-26.07` or `curatorium/php-8.5:qa-26.07-amd64`

Extends the php-base image with QA PHP extensions (installed disabled),
security scanners, and per-`/opt/<tool>/` composer tools. Installed by its
Stewardfile:

```bash
#!/usr/local/bin/steward

apt git
apt openssh-client

# php-extensions
apt php$PHPVS-pcov
apt php$PHPVS-phpdbg
apt php$PHPVS-xdebug

# security-scanners
bin local-php-security-checker https://github.com/fabpot/local-php-security-checker/releases/download/v2.0.6/local-php-security-checker_2.0.6_linux_$ARCH
on-amd64 bin snyk https://downloads.snyk.io/cli/v1.1306.1/snyk-linux
on-arm64 bin snyk https://downloads.snyk.io/cli/v1.1306.1/snyk-linux-arm64
on-amd64 tar gitleaks gitleaks https://github.com/gitleaks/gitleaks/releases/download/v8.21.2/gitleaks_8.21.2_linux_x64.tar.gz
on-arm64 tar gitleaks gitleaks https://github.com/gitleaks/gitleaks/releases/download/v8.21.2/gitleaks_8.21.2_linux_arm64.tar.gz

# composer-tools
composer --dir /opt/codecept
composer --dir /opt/composer-require-checker
composer --dir /opt/composer-unused
composer --dir /opt/easy-config
composer --dir /opt/infection
composer --dir /opt/php-cs-fixer
composer --dir /opt/phpdcd
composer --dir /opt/phpinsights
composer --dir /opt/phplint
composer --dir /opt/phpmnd
composer --dir /opt/phpstan
composer --dir /opt/phpunit
composer --dir /opt/psalm
composer --dir /opt/psysh
composer --dir /opt/var-dumper
```

Each composer tool's exact package set (phpstan's rule plugins, psalm's
plugins, phpunit's paratest, psysh's tinker, ...) is pinned in
`php-qa/files/opt/*/composer.json`, not the Stewardfile.


### PHP FS image `curatorium/php-$PHPVS:fs-$VERSION`
ex.: `curatorium/php-8.5:fs` or `curatorium/php-8.5:fs-26.07` or `curatorium/php-8.5:fs-26.07-amd64`

Extends the php-qa image with Node.js and front-end framework CLIs. Installed
by its Stewardfile:

```bash
#!/usr/local/bin/steward

apt nodejs
npm yarn

# framework-clis
npm @angular/cli
npm grunt-cli
npm @ionic/cli
npm laravel-mix
npm react-cli
npm @symfony/webpack-encore
npm @vue/cli
```

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
