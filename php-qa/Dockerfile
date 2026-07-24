ARG PHPVS
FROM curatorium/php-${PHPVS}:base

ARG PHPVS
ENV PHPVS=${PHPVS} \
    ENABLED_SERVICES=""

COPY files /
COPY mods-available/ /etc/php/${PHPVS}/mods-available/
COPY Stewardfile /tmp/Stewardfile
RUN steward -t php-qa /tmp/Stewardfile && clean-tmp
