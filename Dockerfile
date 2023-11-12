#
# PHP
FROM nginx:bookworm AS base
ARG  PHPVS
ENV  PHPVS  $PHPVS
ARG  X_ARCH
ENV  X_ARCH $X_ARCH

ENV  COMPOSER_ALLOW_SUPERUSER       1
ENV  DEBIAN_FRONTEND                noninteractive
ENV  LANG                           en_US.UTF-8
ENV  LC_ALL                         C.UTF-8
ENV  NGINX_ENVSUBST_TEMPLATE_SUFFIX .tpl
ENV  TERM                           linux
ENV  TZ                             UTC
ENV  VAR_DUMPER_FORMAT              server


COPY files/entrypoint.d           /entrypoint.d
COPY files/etc/init.d/*           /etc/init.d/
COPY files/etc/newrelic/          /etc/newrelic/
COPY files/etc/nginx/templates/*  /etc/nginx/templates/
COPY files/etc/psysh.php          /etc/psysh.php
COPY files/root/.bash*            /root/
COPY files/root/.config/composer  /root/.config/composer
COPY files/usr/local/bin          /usr/local/bin

RUN  add-php && docker-clean;

# tini handles PID=1 @see https://github.com/krallin/tini
ENTRYPOINT  ["tini", "--", "entrypoint"]

STOPSIGNAL SIGTERM
WORKDIR    /app

# NGINX HTTP server
EXPOSE     80
# NGINX HTTPs server
EXPOSE     443
# PHP-FPM server
EXPOSE     9000
# Symfony Dump Server @see https://symfony.com/doc/current/components/var_dumper.html#the-dump-server
EXPOSE     9912


#
# PHP-QA
FROM base AS qa
ARG  PHPVS
ENV  PHPVS  $PHPVS
ARG  X_ARCH
ENV  X_ARCH $X_ARCH

RUN  add-qa && docker-clean;


#
# PHP-FS
FROM qa AS fs
ARG  NODEVS
ENV  NODEVS  $NODEVS
ARG  PHPVS
ENV  PHPVS  $PHPVS
ARG  X_ARCH
ENV  X_ARCH $X_ARCH

RUN  add-node && docker-clean;
