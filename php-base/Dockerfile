ARG PHPVS
FROM curatorium/base

ARG PHPVS
ENV PHPVS=${PHPVS} \
    COMPOSER_ALLOW_SUPERUSER=1 \
    NGINX_ENVSUBST_TEMPLATE_SUFFIX=.tpl \
    ENABLED_SERVICES="php-fpm nginx" \
    VAR_DUMPER_FORMAT=server

COPY --from=nginx:bookworm /docker-entrypoint.d/ /tmp/nginx-entrypoint/
COPY files /
COPY mods-available/ /etc/php/${PHPVS}/mods-available/
COPY Stewardfile /tmp/Stewardfile
RUN steward -t php-base /tmp/Stewardfile \
 && for f in /tmp/nginx-entrypoint/*; do mv "$f" "/entrypoint.d/10-nginx-$(basename "$f")"; done \
 && mv /entrypoint.d/10-nginx-15-local-resolvers.envsh /entrypoint.d/10-nginx-15-local-resolvers.sh \
 && clean-tmp && rm -rf /tmp/nginx-entrypoint

EXPOSE 80 443 9000
