ARG BASE
FROM $BASE

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

ARG VS
RUN apt-get update && apt-get install -y --no-install-recommends														\
		gettext																											\
		nodejs																											\
		php$VS-pcov																										\
 && apt-get autoremove --purge && apt-get clean																			\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*														\
;
RUN npm install -g yarn

RUN phive --no-progress install -g --trust-gpg-keys F4D32E2C9343B2AE	composer-unused
RUN phive --no-progress install -g --trust-gpg-keys C5095986493B4AA0	infection
RUN phive --no-progress install -g --trust-gpg-keys 4AA394086372C20A	phploc
RUN phive --no-progress install -g --trust-gpg-keys 4AA394086372C20A	phpunit
RUN phive --no-progress install -g --force-accept-unsigned				overtrue/phplint

RUN composer global									config --merge -- bin-dir /usr/local/bin
RUN composer global									require bamarni/composer-bin-plugin
RUN composer global bin codecept					require codeception/codeception
RUN composer global bin composer-require-checker	require maglnet/composer-require-checker							\
 || phive --no-progress install -g --trust-gpg-keys D2CCAC42F6295E7D	composer-require-checker@^2.0
RUN composer global bin phpunit						require phpunit/phpunit
RUN composer global bin phpunit						require sebastian/phpcpd
RUN composer global bin phpunit						require phploc/phploc
RUN composer global bin phpstan						require phpstan/phpstan
RUN composer global bin phpstan						require nunomaduro/larastan
RUN composer global bin phpstan						require ekino/phpstan-banned-code
RUN composer global bin psalm						require psalm/plugin-laravel

ADD https://github.com/fabpot/local-php-security-checker/releases/download/v1.0.0/local-php-security-checker_1.0.0_linux_amd64	/usr/local/bin/local-php-security-checker
ADD https://raw.githubusercontent.com/nickjj/wait-until/v0.2.0/wait-until /usr/local/bin/

RUN chmod +x /usr/local/bin/*
RUN rm -fr /root/.cache/*

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
