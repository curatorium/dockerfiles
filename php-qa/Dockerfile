ARG PHPVS
FROM curatorium/php-${PHPVS}:base

ARG PHPVS
ENV PHPVS=${PHPVS}
ENV ENABLED_SERVICES=""

COPY files /
COPY mods-available/ /etc/php/${PHPVS}/mods-available/
COPY Stewardfile /tmp/Stewardfile
RUN steward /tmp/Stewardfile && clean-tmp
