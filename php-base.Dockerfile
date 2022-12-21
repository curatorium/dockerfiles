ARG BASE
FROM ubuntu:$BASE AS PHP-BASE
ARG VS

ENV TERM=linux
ENV DEBIAN_FRONTEND=noninteractive

COPY *.sh ./
RUN bash -ex php-base.sh $VS

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"