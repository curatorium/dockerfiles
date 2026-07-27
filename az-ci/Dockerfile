FROM curatorium/ci

ENV AZURE_CONFIG_DIR=/etc/azure/

COPY files /

COPY Stewardfile /tmp/Stewardfile
RUN steward /tmp/Stewardfile && clean-tmp
