ARG BASE
FROM $BASE

COPY tools/php-serve	/usr/local/bin
RUN  chmod +x			/usr/local/bin/*

ARG VS
RUN apt-get update && apt-get install -y --no-install-recommends														\
		curl																											\
		jq																												\
		git																												\
		less																											\
		nano																											\
		php$VS-phpdbg																									\
		php$VS-xdebug																									\
		php$VS-yaml																										\
 && apt-get autoremove --purge && apt-get clean																			\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*														\
 && chmod +x /usr/local/bin/*																							\
;

CMD "php-serve"
EXPOSE 80

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
