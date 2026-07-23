#
# Base
FROM nginx:bookworm AS base
LABEL org.opencontainers.image.authors="Curatorium"
LABEL org.opencontainers.image.vendor="Curatorium"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/curatorium/dockerfiles"
LABEL org.opencontainers.image.url="https://hub.docker.com/u/curatorium"

ENV  DEBIAN_FRONTEND                noninteractive
ENV  LANG                           en_US.UTF-8
ENV  LC_ALL                         C.UTF-8
ENV  TERM                           linux
ENV  TZ                             UTC

COPY files/root/.bash*              /root/
COPY files/root/.inputrc            /root/
COPY files/root/.jq                 /root/
COPY files/usr/local/bin            /usr/local/bin

RUN  add-base && clean-tmp;

# tini handles PID=1 @see https://github.com/krallin/tini
ENTRYPOINT  ["tini", "--", "entrypoint"]

STOPSIGNAL SIGTERM
WORKDIR    /app

HEALTHCHECK --interval=60s --timeout=2s --start-period=60s --retries=3 CMD healthcheck

# NGINX HTTP server
EXPOSE     80
# NGINX HTTPs server
EXPOSE     443


#
# PHP
FROM base AS php-base
LABEL org.opencontainers.image.authors="Curatorium"
LABEL org.opencontainers.image.vendor="Curatorium"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/curatorium/dockerfiles"
LABEL org.opencontainers.image.url="https://hub.docker.com/u/curatorium"

ARG  PHPVS
ENV  PHPVS  $PHPVS

ENV  COMPOSER_ALLOW_SUPERUSER       1
ENV  NGINX_ENVSUBST_TEMPLATE_SUFFIX .tpl
ENV  ENABLED_SERVICES               "php-fpm nginx"
ENV  VAR_DUMPER_FORMAT              server

COPY files/entrypoint.d             /entrypoint.d
COPY files/etc/init.d/*             /etc/init.d/
COPY files/etc/newrelic/            /etc/newrelic/
COPY files/etc/nginx/templates/*    /etc/nginx/templates/
COPY files/etc/php/mods-available/* /etc/php/$PHPVS/mods-available/
COPY files/opt                      /opt

RUN  add-php && clean-tmp;

# PHP-FPM server
EXPOSE     9000


#
# CI
FROM php-base AS ci
LABEL org.opencontainers.image.authors="Curatorium"
LABEL org.opencontainers.image.vendor="Curatorium"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/curatorium/dockerfiles"
LABEL org.opencontainers.image.url="https://hub.docker.com/u/curatorium"

ARG  NODEVS
ENV  NODEVS  $NODEVS

ENV  AZURE_CONFIG_DIR  /etc/azure/
ENV  ENABLED_SERVICES  ""

COPY files/etc/azure        /etc/azure
COPY files/etc/mysql        /etc/mysql
COPY files/root/.newrelic   /root/.newrelic

RUN  add-az-cli && add-ci && add-docker && add-node && clean-tmp;


#
# PHP-QA
FROM php-base AS qa
LABEL org.opencontainers.image.authors="Curatorium"
LABEL org.opencontainers.image.vendor="Curatorium"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/curatorium/dockerfiles"
LABEL org.opencontainers.image.url="https://hub.docker.com/u/curatorium"

ARG  PHPVS
ENV  PHPVS  $PHPVS

ENV  ENABLED_SERVICES  ""

RUN  add-qa && clean-tmp;


#
# PHP-FS
FROM qa AS fs
LABEL org.opencontainers.image.authors="Curatorium"
LABEL org.opencontainers.image.vendor="Curatorium"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/curatorium/dockerfiles"
LABEL org.opencontainers.image.url="https://hub.docker.com/u/curatorium"

ARG  NODEVS
ENV  NODEVS  $NODEVS

ENV  ENABLED_SERVICES  ""

RUN  add-node && add-node-tools && clean-tmp;
