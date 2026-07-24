FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=linux \
    TZ=UTC

ADD https://github.com/curatorium/steward/releases/latest/download/steward /usr/local/bin/steward
COPY files /
COPY Stewardfile /tmp/Stewardfile
RUN chmod +x /usr/local/bin/steward && steward -t base /tmp/Stewardfile && clean-tmp

ENTRYPOINT ["tini", "--", "entrypoint"]
STOPSIGNAL SIGTERM
WORKDIR /app
HEALTHCHECK CMD ["healthcheck"]
