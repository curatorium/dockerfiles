ARG VS
ARG ORG
FROM $ORG/php-base:$VS
ARG VS

COPY *.sh ./
RUN bash -ex php-cli.sh $VS

WORKDIR	/app
CMD		php -a

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
