FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=linux
ENV TZ=UTC

ADD https://github.com/curatorium/steward/releases/download/v1.0.0-alpha.7/steward /usr/local/bin/steward
RUN chmod +x /usr/local/bin/steward

COPY files /

COPY Stewardfile /tmp/Stewardfile
RUN steward /tmp/Stewardfile && clean-tmp

ENTRYPOINT ["tini", "--", "entrypoint"]
HEALTHCHECK CMD ["healthcheck"]
STOPSIGNAL SIGTERM
WORKDIR /app
