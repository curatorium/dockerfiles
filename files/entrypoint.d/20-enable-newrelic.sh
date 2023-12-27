#!/bin/bash

if [[ ! -z "$NEWRELIC_LICENSE" ]]; then
  # Substitute values from template.
  envsubst < /etc/php/$PHPVS/mods-available/newrelic.ini.tpl > /etc/php/$PHPVS/mods-available/newrelic.ini;

  # Remove unchanged configuration values.
  sed -i -E '/^newrelic.[^=]* = (""){0,1}$/d' /etc/php/$PHPVS/mods-available/newrelic.ini;

  # Enable APM module.
  phpenmod newrelic;
fi
