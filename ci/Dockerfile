FROM curatorium/base

ARG NODEVS
ENV NODEVS=${NODEVS} \
    ENABLED_SERVICES=""

COPY files /
COPY Stewardfile /tmp/Stewardfile
RUN steward -t ci /tmp/Stewardfile && clean-tmp
