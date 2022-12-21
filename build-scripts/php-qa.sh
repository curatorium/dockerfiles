#!/bin/bash -ex
set -ex;
source /opt/build-scripts/common.sh;

apt-get update;

# Add Symfony repository for symfony-cli
curl -1fsSL https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh | bash;
apt-get install -y --no-install-recommends symfony-cli;

# Add pcov (fast code coverage extensions)
apt-get install -y --no-install-recommends php$PHPVS-pcov || true; # fails for PHP<=v7.0

#
# Additional executable tools
#
__bin_add wait-until https://raw.githubusercontent.com/nickjj/wait-until/v0.2.0/wait-until;
__bin_add local-php-security-checker												\
  https://github.com/fabpot/local-php-security-checker/releases/download/v2.0.6/local-php-security-checker_2.0.6_linux_$X_ARCH

#
# Configure Composer with isolated namespaces for global binaries
#
composer self-update;
composer global																		config -- bin-dir /usr/local/bin
composer global																		config -- allow-plugins true || true # fails for composer@1.x;
composer global																		require bamarni/composer-bin-plugin;
composer global																		config --json -- extra.bamarni-bin.bin-links true || true # fails for composer@1.x;
composer global																		config --json -- extra.bamarni-bin.forward-command false || true # fails for composer@1.x;


#
# Install QA packages
#
composer global bin codecept											require codeception/codeception;
composer global bin composer-unused								require icanhazstring/composer-unused || true; # fails for PHP=7.0
composer global bin composer-require-checker			require maglnet/composer-require-checker;
composer global bin infection											config allow-plugins true || true; # fails for composer@1.x
composer global bin infection											require infection/infection;
composer global bin phpdcd												require sebastian/phpdcd;
composer global bin phpmnd												require povils/phpmnd;
composer global bin phpunit												require phpunit/phpunit;
composer global bin phpunit												require sebastian/phpcpd;
composer global bin phpunit												require phploc/phploc;
composer global bin phpunit												require brianium/paratest || true; # fails for PHP=7.3
composer global bin phplint												require overtrue/phplint;
composer global bin phpat													require phpat/phpat || true; # fails for PHP=7.0
composer global bin psalm													require vimeo/psalm;
composer global bin psalm													require psalm/plugin-laravel || true; # fails for PHP=7.0
composer global bin phpstan												config allow-plugins true || true; # fails for composer@1.x
composer global bin phpstan												require phpstan/phpstan;
composer global bin phpstan												require ekino/phpstan-banned-code || true; # fails for PHP<=7.2
composer global bin phpstan												require nunomaduro/larastan || true; # fails for PHP<=7.1
composer global bin phpinsights										config allow-plugins true || true; # fails for composer@1.x
composer global bin phpinsights										require nunomaduro/phpinsights || true; # fails for PHP<=7.1

apt-get autoremove --purge;
