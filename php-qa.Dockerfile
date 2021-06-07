ARG BASE
FROM $BASE

COPY tools/local-php-security-checker	/usr/local/bin/
COPY tools/wait-until					/usr/local/bin/
RUN  chmod +x							/usr/local/bin/*

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

ARG VS
RUN apt-get update && apt-get install -y --no-install-recommends														\
		gettext																											\
		nodejs																											\
		php$VS-pcov																										\
 && apt-get autoremove --purge && apt-get clean																			\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*														\
;

RUN phive --no-progress install -g --trust-gpg-keys F4D32E2C9343B2AE	composer-unused									\
 && phive --no-progress install -g --trust-gpg-keys 033E5F8D801A2F8D	composer-require-checker						\
 && phive --no-progress install -g --trust-gpg-keys C5095986493B4AA0	infection										\
 && phive --no-progress install -g --trust-gpg-keys 4AA394086372C20A	phploc											\
 && phive --no-progress install -g --trust-gpg-keys 4AA394086372C20A	phpunit											\
 && phive --no-progress install -g --force-accept-unsigned				overtrue/phplint								\
;

RUN composer global config --merge -- bin-dir /usr/local/bin															\
 && composer global require bamarni/composer-bin-plugin																	\
 && composer global bin psalm require psalm/plugin-laravel																\
 && composer global bin phpstan require nunomaduro/larastan																\
 && rm -fr /root/.cache/*																								\
;

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
