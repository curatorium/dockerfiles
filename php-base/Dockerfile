ARG PHPVS
FROM curatorium/base

ARG PHPVS
ENV PHPVS=${PHPVS}
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV NGINX_ENVSUBST_TEMPLATE_SUFFIX=.tpl
ENV ENABLED_SERVICES="php-fpm nginx"
ENV VAR_DUMPER_FORMAT=server

COPY files /
COPY --from=nginx:bookworm /docker-entrypoint.d/ /tmp/nginx-entrypoint/
COPY mods-available/ /etc/php/${PHPVS}/mods-available/

COPY Stewardfile /tmp/Stewardfile

RUN steward /tmp/Stewardfile && relocate-nginx-entrypoint && clean-tmp

EXPOSE 80 443 9000
