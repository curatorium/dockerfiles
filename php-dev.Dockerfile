ARG BASE
FROM $BASE

COPY docker/docker.gpg	/usr/share/keyrings/
COPY docker/docker.list	./
COPY tools/php-serve	/usr/local/bin

ARG VS
RUN apt-get update && apt-get install -y --no-install-recommends														\
		lsb-release																										\
 && sed "s/XYZXYZXYZ/$(lsb_release -cs)/" docker.list > /etc/apt/sources.list.d/docker.list								\
 && apt-get update && apt-get install -y --no-install-recommends														\
		curl																											\
		docker-ce-cli																									\
		jq																												\
		less																											\
		nano																											\
		php$VS-phpdbg																									\
		php$VS-xdebug																									\
		ssh 																											\
		wget																											\
		php$VS-yaml																										\
 && apt-get autoremove --purge																							\
 && apt-get clean																										\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*														\
 && chmod +x /usr/local/bin/*																							\
 && phive --no-progress install -g --trust-gpg-keys FD5CFD96854EBC5D pipelines											\
 && chmod +x /usr/local/bin/*																							\
;

EXPOSE 80
CMD "php-serve"

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
