FROM curatorium/base

ARG NODEVS
ENV NODEVS=${NODEVS}
ENV ENABLED_SERVICES=""

COPY files /

COPY Stewardfile /tmp/Stewardfile
RUN steward /tmp/Stewardfile && clean-tmp
