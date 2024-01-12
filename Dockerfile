#
# PHP
FROM nginx:bookworm AS base
MAINTAINER Mihai Stancu <mihai.stancu@neurony.ro>

ARG  PHPVS
ENV  PHPVS  $PHPVS
ARG  X_ARCH
ENV  X_ARCH $X_ARCH

ENV  COMPOSER_ALLOW_SUPERUSER       1
ENV  CRON_ENABLED                   0
ENV  DEBIAN_FRONTEND                noninteractive
ENV  DUMPER_ENABLED                 0
ENV  LANG                           en_US.UTF-8
ENV  LC_ALL                         C.UTF-8
ENV  NEWRELIC_ENABLED               0
ENV  NGINX_ENVSUBST_TEMPLATE_SUFFIX .tpl
ENV  NGINX_ENABLED                  1
ENV  PHPFPM_ENABLED                 1
ENV  TERM                           linux
ENV  TZ                             UTC
ENV  VAR_DUMPER_FORMAT              server

COPY files/entrypoint.d             /entrypoint.d
COPY files/etc/init.d/*             /etc/init.d/
COPY files/etc/newrelic/            /etc/newrelic/
COPY files/etc/nginx/templates/*    /etc/nginx/templates/
COPY files/etc/php/mods-available/* /etc/php/$PHPVS/mods-available/
COPY files/root/.bash*              /root/
COPY files/opt                      /opt
COPY files/usr/local/bin            /usr/local/bin

RUN  add-php && clean-tmp;

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
# PHP-DUMPER
FROM base AS dumper
MAINTAINER Mihai Stancu <mihai.stancu@neurony.ro>

ENV  CRON_ENABLED                   0
ENV  DUMPER_ENABLED                 1
ENV  NEWRELIC_ENABLED               0
ENV  NGINX_ENABLED                  0
ENV  PHPFPM_ENABLED                 0

RUN cd /opt/var-dumper && composer install && clean-tmp;


#
# CLOUD-CLI
FROM base AS cloud-cli
MAINTAINER Mihai Stancu <mihai.stancu@neurony.ro>

ENV  AZURE_CONFIG_DIR  /etc/azure/
ENV  CRON_ENABLED                   0
ENV  DUMPER_ENABLED                 0
ENV  NEWRELIC_ENABLED               0
ENV  NGINX_ENABLED                  0
ENV  PHPFPM_ENABLED                 0

COPY files/etc/azure   /etc/azure
COPY files/etc/mysql   /etc/mysql

RUN  add-config && add-docker && add-az-cli && clean-tmp;


#
# PHP-QA
FROM base AS qa
MAINTAINER Mihai Stancu <mihai.stancu@neurony.ro>

ARG  PHPVS
ENV  PHPVS  $PHPVS
ARG  X_ARCH
ENV  X_ARCH $X_ARCH

RUN  add-qa && clean-tmp;


#
# PHP-FS
FROM qa AS fs
MAINTAINER Mihai Stancu <mihai.stancu@neurony.ro>

ARG  NODEVS
ENV  NODEVS  $NODEVS
ARG  X_ARCH
ENV  X_ARCH $X_ARCH

RUN  add-node && clean-tmp;
