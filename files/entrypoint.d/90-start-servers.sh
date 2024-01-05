#!/bin/bash

[[ "$NEWRELIC_ENABLED" == "1" ]] && [[ ! -z "$NEWRELIC_LICENSE" ]] && /etc/init.d/newrelic-daemon start;
[[ "$CRON_ENABLED"     == "1" ]] && /etc/init.d/cron start;
[[ "$PHPFPM_ENABLED"   == "1" ]] && /etc/init.d/php-fpm start;
[[ "$DUMPER_ENABLED"   == "1" ]] && /etc/init.d/var-dump start;
[[ "$NGINX_ENABLED"    == "1" ]] && nginx-entrypoint nginx;
