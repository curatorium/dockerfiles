ARG VS
ARG ORG
FROM $ORG/php-cli:$VS
ARG VS

COPY *.sh ./
RUN bash -ex php-fpm.sh $VS

ENV VSx="$VS"

EXPOSE		9000
STOPSIGNAL	SIGQUIT
CMD		/usr/sbin/php-fpm$VSx -F -O

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
