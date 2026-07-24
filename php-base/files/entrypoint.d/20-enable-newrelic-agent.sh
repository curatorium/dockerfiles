#!/bin/bash

# Substitute values from template.
envsubst-only-prefix "NEWRELIC_" < /etc/php/$PHPVS/mods-available/newrelic.ini.tpl > /etc/php/$PHPVS/mods-available/newrelic.ini;

# Remove unchanged configuration values.
sed -i -E '/= "?\$\w*"? ; override$/d' /etc/php/$PHPVS/mods-available/newrelic.ini

# Enable APM module.
[[ ! -z "$NEWRELIC_ENABLED" ]] && (dpkg-query -l newrelic-php5 2>&1 1>/dev/null) && phpenmod newrelic;
