ARG VS
ARG ORG
FROM $ORG/php-qa:$VS
ARG VS

COPY *.sh ./
RUN bash -ex php-dev.sh $VS

COPY tools/php-serve	/usr/local/bin
RUN  chmod +x			/usr/local/bin/*

EXPOSE	80
CMD		php-serve

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
