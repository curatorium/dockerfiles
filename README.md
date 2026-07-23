Curatorium PHP Dockerfiles
======================================================================

## About

This repository contains the Dockerfiles used to build the multi-arch (AMD64 +
ARM64) PHP images found at https://hub.docker.com/u/curatorium, for PHP 8.0
through 8.5.

They aim to:
- be compatible with [Symfony](http://symfony.com/) & [Laravel](https://laravel.com/) basic requirements
- support commonly used extensions (`gd`, `mysql`, `redis`, etc.)
- be useful in ci/cd pipelines to run tests and quality gates
- include useful PHP tools (`composer`, `phpunit`, `phpstan`, etc.)

PHP packages come from the [deb.sury.org](https://deb.sury.org/) repository
(the Debian counterpart of the `ondrej/php` PPA). The images are built and
published by GitHub Actions on native per-architecture runners, on demand.

## Image naming convention

Image naming & tagging format:
  ```
   (8.0 ... 8.5)      YY.MM
         ▼              ▼
  php-<PHPVS>:<role>-<version>
                ▲
          base|ci|qa|fs
  ```

- Roles: `base`, `ci`, `qa`, `fs`
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

## Repositories `curatorium/php-$PHPVS`
ex.: [curatorium/php-8.5](https://hub.docker.com/r/curatorium/php-8.5)


### Base image `curatorium/php-$PHPVS:base-$VERSION`
ex.: `curatorium/php-8.5:base` or `curatorium/php-8.5:base-26.06` or `curatorium/php-8.5:base-26.06-amd64`

Built on `nginx:bookworm`. PHP extensions:

- `amqp`, `apcu`, `bcmath`, `curl`, `gd`, `grpc`, `http`, `igbinary`, `imagick`,
  `intl`, `mbstring`, `memcached`, `mongodb`, `msgpack`, `mysql`, `odbc`,
  `opcache`, `pgsql`, `protobuf`, `raphf`, `readline`, `redis`, `soap`,
  `sqlite3`, `ssh2`, `stomp`, `timezonedb`, `xml`, `xsl`, `yaml`, `zip`, `zmq`

Tools:

- `composer`
- `nginx`
- `php-fpm`
- `cron`
- `tini` (PID 1 / init)
- `wait-until`
- `bash-import`, `bash-test`, `steward`
- image optimisers: `ghostscript`, `imagemagick`, `jpegoptim`, `optipng`, `pngquant`, `gifsicle`
- `jq`, `nano`, `unzip`


### CI image `curatorium/php-$PHPVS:ci-$VERSION`
ex.: `curatorium/php-8.5:ci` or `curatorium/php-8.5:ci-26.06` or `curatorium/php-8.5:ci-26.06-amd64`

Extends the base image with CLI tooling for pipelines — preparing deployments,
rendering configuration, building images:

- `az` (Azure CLI)
- `docker` (CLI + `compose` plugin + `buildx`)
- `kubectl`, `kubelogin`, `krew`
- `node`, `yarn`
- `ejson`, `skeema`, `yq`, `q`, `pup`, `gron`, `httpie`
- `newrelic-cli`
- `git`, `openssh-client`
- `mariadb-client`, `redis-tools`, `libmemcached-tools`


### QA image `curatorium/php-$PHPVS:qa-$VERSION`
ex.: `curatorium/php-8.5:qa` or `curatorium/php-8.5:qa-26.06` or `curatorium/php-8.5:qa-26.06-amd64`

Extends the base image with PHP extensions:

- `pcov` -- disabled by default
- `xdebug` -- disabled by default
- `phpdbg`

Security scanners:

- `gitleaks` -- secret scanner
- `snyk`
- `local-php-security-checker`

...and PHP tools (each in its own `/opt/<tool>/`):

- `codeception`
- `composer-require-checker`
- `composer-unused`
- `easy-config`
- `infection`
- `php-cs-fixer`
- `phpdcd`
- `phpinsights`
- `phplint`
- `phpmnd`
- `phpstan`
- `phpunit`
- `psalm`
- `psysh` -- a much improved PHP interactive shell
- `var-dumper`


### FS image `curatorium/php-$PHPVS:fs-$VERSION`
ex.: `curatorium/php-8.5:fs` or `curatorium/php-8.5:fs-26.06` or `curatorium/php-8.5:fs-26.06-amd64`

Extends the QA image with `nodejs`, `npm`, `npx`, `yarn`, and front-end
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

Clone this repo, set up your preferred environment variables (there's an
`.env.sample` file available) then run `docker compose build`.

```
  git clone git@github.com:curatorium/dockerfiles.git;
  cd dockerfiles/;

  cp .env.sample .env
  nano .env # specify a PHP version ($PHPVS) and Node version ($NODEVS)

  docker compose build

  # or build a specific version of PHP, with a specific Node version and timestamp
  PHPVS=8.5 NODEVS=25 TS=`date +%y.%m` docker compose build
```

Multi-arch images are produced by the GitHub Actions build, which builds AMD64
and ARM64 on native runners, pushes each by digest with build provenance and an
SBOM attestation, and combines them into a manifest per role.

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
