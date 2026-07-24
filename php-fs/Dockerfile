ARG PHPVS
FROM curatorium/php-${PHPVS}:qa

ARG NODEVS
ENV NODEVS=${NODEVS} \
    ENABLED_SERVICES=""

COPY Stewardfile /tmp/Stewardfile
RUN steward -t php-fs /tmp/Stewardfile && clean-tmp
