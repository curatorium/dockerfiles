#!/bin/bash

[[ ! -z "$NEWRELIC_LICENSE" ]] && /etc/init.d/newrelic-daemon start;

[[ "$CRON_ENABLED" == "1" ]] && /etc/init.d/cron start;

/etc/init.d/php-fpm start;

[[ "$VAR_DUMP_ENABLED" == "1" ]] && /etc/init.d/var-dump start;

nginx-entrypoint nginx;
