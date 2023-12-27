Neurony PHP Dockerfiles
======================================================================

## About

This repository contains the Dockerfiles used to build the PHP images found at https://hub.docker.com/u/neurony.

They aim to:
- be compatible with [Symfony](http://symfony.com/) & [Laravel](https://laravel.com/) basic requirements
- support commonly used extensions (`gd`, `mysql`, `redis`, etc.)
- be useful in ci/cd pipelines to run tests and quality gates
- include useful PHP tools (`composer`, `phpunit`, `phpstan`, etc.)

We rely on the PHP package repository provided by [ondrej/php](https://launchpad.net/~ondrej/+archive/ubuntu/php) PPA.

## Image naming convention

Image naming & tagging format:
  ```
   (8.0 ... 8.2)      YY.MM
         ▼              ▼
  php-<PHPVS>:<role>-<semver>-<arch>
                ▲               ▲
           base|qa|fs      amd64|arm64
  ```

The `<semver>` value can be `latest` or an incremental version number (expressed as `YY.MM`).
The `<arch>` can be omitted because the images are multi-arch.

There are several multi-arch aliases for `php-$PHPVS:$ROLE-$SEMVER-*`
- `php-$PHPVS:$ROLE-$SEMVER` -- the arch is selected based on your system
- `php-$PHPVS:$ROLE` -- the `<semver>` is assumed to be `latest`

For the base image there are 2 more shortcuts:
- `php-$PHPVS:$SEMVER` -- equivalent to `php-$PHPVS:base-$SEMVER`
- `php-$PHPVS:latest` -- equivalent to `php-$PHPVS:base`

## Usage
As a server:
  ```bash
  docker run -v "$PWD:/app" neurony/php-8.2:latest # will start nginx + php-fpm (+ crond + var-dump; if enabled)
  ```
  or
  ```yaml
  # docker-compose.yml
  services:
    backend:
      image: neurony/php-8.2:latest
      ports: 
        - 80:80     # served by NGINX by default
  ```

As a command runner:
  ```bash
  docker run -v "$PWD:/app" neurony/php-8.2:latest php /app/command.php # will execute your command & exit
  ```

As a pipeline runner:
  ```yaml
  # bitbucket-pipelines.yml
  - step:
      image: neurony/php-8.2:qa
      script:
        - phpstan
  ```

## Repositories `neurony/php-$PHPVS`
ex.: [neurony/php-8.2](https://hub.docker.com/r/neurony/php-8.2)


### Base Image `neurony/php-$PHPVS:base-$SEMVER`
ex.: `neurony/php-8.2:base` or `neurony/php-8.2:base-23.11` or `neurony/php-8.2:base-23.11-amd64`

- PHP Extensions:
  - `php-amqp`
  - `php-bcmath`
  - `php-curl`
  - `php-gd`
  - `php-grpc`
  - `php-http`
  - `php-igbinary`
  - `php-imagick`
  - `php-intl`
  - `php-mbstring`
  - `php-memcached`
  - `php-mongodb`
  - `php-msgpack`
  - `php-mysql`
  - `php-newrelic`
  - `php-odbc`
  - `php-pgsql`
  - `php-protobuf`
  - `php-raphf`
  - `php-redis`
  - `php-soap`
  - `php-sqlite3`
  - `php-ssh2`
  - `php-stomp`
  - `php-timezonedb`
  - `php-xml`
  - `php-xsl`
  - `php-yaml`
  - `php-zip`
  - `php-zmq`
- Tools:
  - `composer`
  - `cron`
  - `nginx`
  - `php-fpm`


### QA image `neurony/php-$PHPVS:qa-$SEMVER`
ex.: `neurony/php-8.2:qa` or `neurony/php-8.2:qa-23.11` or `neurony/php-8.2:qa-23.11-amd64`

Extends the main image with the following PHP Extensions:
  - `php-pcov` -- disabled by default
  - `php-phpdbg`
  - `php-xdebug` -- disabled by default

...and tools:
  - `codeception`
  - `composer-require-checker`
  - `composer-unused`
  - `envsubst`
  - `infection`
  - `local-php-security-checker`
  - `paratest`
  - `phpat`
  - `phpcpd`
  - `phpinsights`
  - `phplint`
  - `phploc`
  - `phpmnd`
  - `phpstan` + `ekino/phpstan-banned-code` + `nunomaduro/larastan`
  - `phpunit`
  - `psalm` + `psalm/plugin-laravel`
  - `psysh` -- a much improved PHP interactive shell
  - `nickjj/wait-until`

### FS images `neurony/php-$PHPVS:fs-$SEMVER`
ex.: `neurony/php-8.2:fs` or `neurony/php-8.2:fs-23.1` or `neurony/php-8.2:fs-23.11-amd64`

Extends the QA image with the following tools:
  - `nodejs`
  - `npm`
  - `npx`
  - `yarn`


### `add-config` & `add-debug` scripts

We previously offered a dev image that contained tools for developers to debug their local environments.  This is no longer an image, it's a script that can be run on any of the images when you need those tools.

Tools installed by `add-config` script:
- `7zip`
- `envsubst` -- already present in base image
- `jq` -- see https://jqlang.github.io/jq/
- `q` -- see https://harelba.github.io/q/
- `tar`
- `unzip`
- `yq` -- see https://mikefarah.gitbook.io/yq/
- `zip`

Tools installed by `add-debug` script:
  - `dig`
  - `less`
  - `libmemcached-tools`
  - `mysql-client`
  - `nano`
  - `netcat`
  - `ping`
  - `redis-tools`
  - `telnet`
  - `vim`

----------------------------------------------------------------------

## Build

Clone this repo, setup your preferred environment variables (there's an .env.sample file available) then run `docker compose build`.

```
  git clone git@github.com:Neurony/php-dockerfiles.git;
  cd php-dockerfiles/;

  cp .env.sample .env
  nano .env # specify a platform architecture ($X_ARCH) and PHP version ($PHPVS)

  docker compose build

  # or building a specific version of PHP, with a specific version of NodeJS, and a specific timestamp
  PHPVS=8.2 NODEVS=18 TS=`date +%Y%m` docker compose build
  
  # or use the ./build script to build all images
  ./build

  # or use the ./build script to build specific images based on your needs
  ./build nopush "8.0 8.2" "arm64" latest
```

### Contributing

Pull requests welcome
