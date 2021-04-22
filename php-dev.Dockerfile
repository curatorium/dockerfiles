ARG BASE
FROM $BASE

COPY docker/docker.gpg		/usr/share/keyrings/
COPY docker/docker.list		./

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
;

EXPOSE 80
CMD if [ -d "public/" ]; then php -S 0.0.0.0:80 -t public/; else php -S 0.0.0.0:80; fi;

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
