ARG BASE
FROM $BASE

COPY node/nodesource.gpg				/usr/share/keyrings/
COPY node/nodesource.list				./
COPY tools/local-php-security-checker	/usr/local/bin/
COPY tools/wait-until					/usr/local/bin/

ARG VS
RUN apt-get update && apt-get install -y --no-install-recommends														\
		lsb-release																										\
 && sed "s/XYZXYZXYZ/$(lsb_release -cs)/" nodesource.list > /etc/apt/sources.list.d/nodesource.list						\
 && apt-get update && apt-get install -y --no-install-recommends														\
		gettext																											\
		git																												\
		nodejs																											\
		php$VS-pcov																										\
 && apt-get autoremove --purge																							\
 && apt-get clean																										\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*														\
 && chmod +x /usr/local/bin/*																							\
 && phive --no-progress install -g --trust-gpg-keys F4D32E2C9343B2AE	composer-unused									\
 && phive --no-progress install -g --trust-gpg-keys 033E5F8D801A2F8D	composer-require-checker						\
 && phive --no-progress install -g --trust-gpg-keys C5095986493B4AA0	infection										\
 && phive --no-progress install -g --trust-gpg-keys 4AA394086372C20A	phploc											\
 && phive --no-progress install -g --trust-gpg-keys 4AA394086372C20A	phpunit											\
 && phive --no-progress install -g --force-accept-unsigned				overtrue/phplint								\
 && phive --no-progress install -g --force-accept-unsigned				paratest										\
;

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
