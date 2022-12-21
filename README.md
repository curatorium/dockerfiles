Neurony PHP Dockerfiles
======================================================================

## About

This repository contains the Dockerfiles used to build the PHP images found at https://hub.docker.com/u/neurony.

They aim to:
- be compatible with [Symfony](http://symfony.com/) & [Laravel](https://laravel.com/) basic requirements
- support commonly used extensions (`gd`, `mysql`, `redis`, etc.)
- be used in ci/cd pipelines to run tests and quality gates
- include useful PHP tools (`composer`, `phpunit`, `phpstan`, etc.)

We rely on the PHP package repository provided by [ondrej/php](https://launchpad.net/~ondrej/+archive/ubuntu/php) PPA.

## Image naming convention

#### Long format:

```
 (7.0 ... 8.2)       YY.MM
       ▼               ▼
php-<PHPVS>:<role>-<semver>-<arch>
               ▲               ▲
       cli|fpm|qa|fs|dev  amd64|arm64
```

#### Short format:

```
php-<PHPVS>:<role> # with semver=latest & arch=amd64
```


## Usage

- The CLI image is meant to be used as a build base for cronjobs and consumers (via orchestration in `docker-compose.yml`).
- The FPM image is meant to be used as a build base for NGINX+FCGI setups (via orchestrations in `docker-compose.yml`).
- The QA image is meant to be used in a CI/CD pipeline leveraging its PHP tools (to run static code analysis, test suites, etc.).
- The DEV image is meant for local development to help reproduce issues found in pipelines and offer the full PHP tools suite to help manually rerun checks locally.

----------------------------------------------------------------------

### Images

Repositories have the format: `neurony/php-$PHPVS`, ex.: [neurony/php-8.1](https://hub.docker.com/r/neurony/php-8.1)

#### CLI Images
- Image tags: `neurony/php-$PHPVS:cli-$TIMESTAMP`, ex.: `neurony/php-8.1:cli-latest`
- Entrypoint: `php -a` -- the PHP built-in interactive shell
- PHP Extensions:
  - `php-acpu`
  - `php-bcmath`
  - `php-curl`
  - `php-gd`
  - `php-http` -- for <=8.0
  - `php-imagick`
  - `php-intl`
  - `php-mbstring`
  - `php-memcached`
  - `php-mongodb`
  - `php-mysql`
  - `php-opcache`
  - `php-pgsql`
  - `php-propro` -- for <=8.0
  - `php-raphf` -- for <=8.0
  - `php-readline`
  - `php-redis`
  - `php-sqlite`
  - `php-xml`
  - `php-zip`
- Tools:
  - `composer`
  - `imagemagick`
  - `gifsicle`
  - `jpegoptim`
  - `optipng`
  - `pngquant`


#### FPM images
- Image tags: `neurony/php-$PHPVS:fpm-$TIMESTAMP`, ex.: `neurony/php-8.1:fpm-latest`
- Extends the CLI image
- Entrypoint: `php-fpm` -- the PHP FCGI server meant to be used in conjunction with a webserver (exposes port `9000`)

#### QA images

For images <= 7.4 some packages listed below cannot be installed.

- Image tags: `neurony/php-$PHPVS:qa-$TIMESTAMP`, ex.: `neurony/php-8.1:qa-latest`
- Extends the FPM image
- Entrypoint: Starts `php-fpm` as a service in the background and `php -a` in the foreground
- PHP Extensions:
  - `php-pcov` -- enabled by default
- Tools:
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
  - `nickjj/wait-until`

#### FS images

- Image tags: `neurony/php-$PHPVS:fs-$TIMESTAMP`, ex.: `neurony/php-8.1:fs-latest`
- Extends the QA image
- Tools:
  - `nodejs`
  - `npm`
  - `npx`


#### DEV images

- Image tags: `neurony/php-$PHPVS:dev-$TIMESTAMP`, ex.: `neurony/php-8.1:dev-latest`
- Extends the QA image
- Entrypoint: Start `php-fpm` and `php -S` as services in the background (exposes ports `9000` and `80`), and `psysh` or `php -a` in the foreground 
- PHP Extensions:
  - `php-pcov` -- here it's disabled by default
  - `php-xdebug` -- disabled by default
  - `php-yaml`
  - `php-phpdbg`
- Tools:
  - `cron`
  - `curl` 
  - `git`
  - `jq`
  - `less`
  - `man`
  - `mysql-client`
  - `nano`
  - `ping`
  - `psysh` -- a much improved PHP interactive shell
  - `redis-tools`
  - `ssh`
  - `telnet`
  - `vim`

----------------------------------------------------------------------

## Build

Clone this repo, setup your preferred environment variables (there's an .env.example file available) then just run `docker compose build`.


```
  git clone git@github.com:Neurony/php-dockerfiles.git;
  cd php-dockerfiles/;

  cp .env.examples .env
  nano .env # specify a platform architecture ($X_ARCH) and PHP version ($PHPVS)
  
  docker compose build

  # or building a specific version of PHP, with a specific version of NodeJS, and a specific timestamp
  PHPVS=8.1 NODEVS=18 TS=`date +%Y%m` docker compose build
```

### Contributing

Pull requests welcome
