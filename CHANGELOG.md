CHANGELOG
====================================================================================================

### 2024-01
1. Added "dumper", an image to run var-dump-server and aggregate dump() output from all services
1. Added "cloud-cli", an image to use in pipelines where az-cli, docker, docker-compose, kubectl, mysql might come in handy
1. Enable/disable daemons (nginx, fpm, cron, var-dumper, newrelic)
1. NewRelic configuration handled generically (+ bugfix)
1. Bash aliases can find bin/console & vendor/bin/psysh even if you're in a subdir (+ Symfony shortcuts)
1. Upgrading Node to v20.x

### 2023-11
1. Upgraded underlying OS version
1. Migrated to a Debian based image
1. Migrated to nginx:bookworm as base image (official nginx image)
1. Merged PHP-CLI & PHP-FPM into a single image
1. Dropped support for the php-http service -- replaced by nginx
1. Dropped the PHP-DEV image; replaced by a command (`add-debug`) to installs tools
1. `www-data` assumes the ID of the owner of the /app dir (at boot)

### 2023-09
1. Dropped support for PHP versions <8.x
1. Complete ARM64 support with multi-arch images (docker manifests)

### 2022-09
1. ARM64 support via buildx

### 2022-12
1. Images for PHP v8.2
1. pcov now disabled by default in DEV images (performance improvement)
1. [Symfony Dump Server](https://symfony.com/doc/current/components/var_dumper.html#the-dump-server) is now installed on dev images and opened as an `/etc/init.d` service which dumps to the docker STDOUT
1. FPM & the HTTP server now run as `www-data` (not as root)
1. `www-data` now has a configurable $UID:$GID which defaults to 1000:1000 to enable local-development files to remain owned by the host machine's user
1. Background services (php-fpm, php-http) are managed by `/etc/init.d`
1. The utility `php-serve` was renamed to `php-http` and is now an `/etc/init.d` service capable of being stopped and started without killing the docker container 
1. QA now handles both FPM in the background & the built-in interactive PHP shell in the foreground
1. DEV now handles FPM & HTTP in the background + PsySH interactive PHP shell in the foreground
1. [Tini](https://github.com/krallin/tini/) is now installed and handles the entrypoint as an init process

### 2022-10
1. Removed Makefile from the build process
1. Building is 100% `docker compose build` and configuration is in `.env`
1. You can target your build to a custom platform (ex.: ARM64 for newer Macs)
