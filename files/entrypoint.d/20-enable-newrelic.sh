#!/bin/bash

if [[ ! -z "$NEWRELIC_LICENSE" ]] && (dpkg-query -l newrelic-php5 1>/dev/null 2>/dev/null); then
  # Substitute values from template.
  envsubst-only-prefix "NEWRELIC_" < /etc/php/$PHPVS/mods-available/newrelic.ini.tpl > /etc/php/$PHPVS/mods-available/newrelic.ini;

  # Remove unchanged configuration values.
  sed -i -E '/= "?\$\w*"? ; override$/d' /etc/php/$PHPVS/mods-available/newrelic.ini

  # Enable APM module.
  phpenmod newrelic;
fi
