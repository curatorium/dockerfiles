#!/bin/bash -ex

set -ex;

source common.sh;

VS=$1; shift;

nrn-add-packages php$VS-pcov;
phpenmod pcov;


#
# Installing Node + NPM
#
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
nrn-add-packages gettext nodejs;
npm install -g yarn


#
# Installing Composer
#
curl -fsSL -o /usr/local/bin/composer https://github.com/composer/composer/releases/download/2.2.6/composer.phar;


#
# Additional executable tools
#
curl -fsSL -o /usr/local/bin/local-php-security-checker												\
 https://github.com/fabpot/local-php-security-checker/releases/download/v1.2.0/local-php-security-checker_1.2.0_linux_amd64
curl -fsSL -o /usr/local/bin/wait-until https://raw.githubusercontent.com/nickjj/wait-until/v0.2.0/wait-until

chmod +x /usr/local/bin/*;


#
# Configure Composer
#
composer self-update;
composer global																		config -- allow-plugins true;
composer global																		config -- bin-dir /usr/local/bin
composer global																		require bamarni/composer-bin-plugin;


#
# Install QA packages
#
composer global bin codecept											require codeception/codeception;
composer global bin composer-require-checker			require maglnet/composer-require-checker;
composer global bin infection											config -- allow-plugins true || true;
composer global bin infection											require infection/infection;
composer global bin phpmnd												require povils/phpmnd;
composer global bin phpunit												require 										\
		phpunit/phpunit																														\
		sebastian/phpcpd																													\
		phploc/phploc																															\
		brianium/paratest																													\
;
composer global bin phplint												require overtrue/phplint;
composer global bin phpstan												config -- allow-plugins true || true;
composer global bin phpstan												require phpstan/phpstan;
composer global bin composer-unused								require icanhazstring/composer-unused;
composer global bin phpat													require phpat/phpat;
composer global bin psalm													require psalm/plugin-laravel;
composer global bin phpstan												require											\
    nunomaduro/larastan																												\
    ekino/phpstan-banned-code																									\
;
composer global bin phpinsights									config -- allow-plugins true || true;
composer global bin phpinsights									require nunomaduro/phpinsights;

rm -fr /root/.composer/cache/*;
