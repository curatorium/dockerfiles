ARG PHPVS
FROM curatorium/php-${PHPVS}:qa

ARG NODEVS
ENV NODEVS=${NODEVS}
ENV ENABLED_SERVICES=""

COPY Stewardfile /tmp/Stewardfile
RUN steward /tmp/Stewardfile && clean-tmp
