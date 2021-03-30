Neurony PHP Dockerfiles
======================================================================

## About

This repository contains the Dockerfiles used to build the PHP images found at https://hub.docker.com/u/neurony.

They aim to:
- be compatible with [Symfony](http://symfony.com/) & [Laravel](https://laravel.com/) basic requirements
- support commonly used extensions (`gd`, `mysql`, etc.)
- be used in ci/cd pipelines to run tests and quality gates

They are based on [phpdockerio](https://hub.docker.com/u/phpdockerio) images which in turn use [ondrej/php](https://launchpad.net/~ondrej/+archive/ubuntu/php) PPA.

PHP versions available are: `7.2`, `7.3`, `7.4` & `8.0`.


## Usage

The CLI and FPM images are meant to be used as a build base or in orchestrations (ex.: `docker-compose.yml` file).

The QA image is meant to be used in a ci/cd pipeline such as `bitbucket-pipelines.yml`.

The DEV image can be run either `docker`:

```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v "$(PWD):/app" -p 80:80 neurony/php-dev:8.0
```

Or using `docker-compose` and referencing the `docker-compose.yml`
```bash
export VS=7.2; # specify PHP version for server
docker-compose -f /path/to/neurony-php-dockerfiles/docker-compose.yml run app;
```

The DEV image also has [`ktomk/pipelines`](https://github.com/ktomk/pipelines) and can execute your `bitbucket-pipeline.yml` locally if you mount the `docker.sock`.
```makefile
docker-compose -f /path/to/neurony-php-dockerfiles/docker-compose.yml run app pipelines --trigger 'pr:development';
```


----------------------------------------------------------------------

### Images

#### CLI Images
- Images: [neurony/php-cli:*](https://hub.docker.com/r/neurony/php-cli)
- Default CMD: `php`
- PHP Extensions:
    - `php-bcmath`
    - `php-gd`
    - `php-intl`
    - `php-memcached`
    - `php-mongo`
    - `php-mysql`
    - `php-pgsql`
    - `php-redis`
    - `php-sqlite`
- Tools:
    - `phive`
    - `composer`

#### FPM images
- Images: [neurony/php-fpm:*](https://hub.docker.com/r/neurony/php-fpm)
- Default CMD: `php-fpm` (exposes port `9000`)
- Based on the CLI image

#### QA images
- Images: [neurony/php-qa:*](https://hub.docker.com/r/neurony/php-qa)
- Default CMD: `php`
- Based on the CLI image
- PHP Extensions:
    - `php-pcov`
- Tools:
    - `composer-unused`
    - `composer-require-checker`
    - `infection`
    - `local-php-security-checker`
    - `phploc`
    - `phpunit`
    - `phplint`
    - `paratest`
    - `nickjj/wait-until`

#### DEV images
- Images: - Images: [neurony/php-dev:*](https://hub.docker.com/r/neurony/php-dev)
- Default CMD: `php -S 0.0.0.0:80` (exposes port `80`)
- Based on the QA image
- Tools:
    - `curl`
    - `docker`
    - `git`
    - `jq`
    - `less`
    - `nano`
    - `php-phpdbg`
    - `pipelines`
    - `wget`

----------------------------------------------------------------------

### Build the images

Build a specific image:
```bash
make neurony/php-cli:8.0
```

Build all images for a specific version:
```bash
make neurony/php:8.0
```

Build all images `(7.2 .. 8.0)` &times; `(cli | fpm | qa | dev)`:
```bash
make neurony/php
```

### Contributing

Pull requests welcome