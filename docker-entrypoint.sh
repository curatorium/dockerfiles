#!/bin/bash

#
# Start PHP-FPM server (if it's installed).
#
if [[ -f /etc/init.d/php-fpm ]]; then
  service php-fpm start;
fi

#
# Start PHP-HTTP server (if it's installed).
#
if [[ -f /etc/init.d/php-http ]]; then
  service php-http start;
fi

#
# Start Symfony Dump Server
#
if [[ -f /etc/init.d/var-dump ]]; then
  service var-dump start;
fi

#
# Keep process running forever if it's not an interactive shell.
#
if [[ ! -t 0 ]]; then
  sleep infinity;
fi

#
# If PsySH is installed then use it as the interactive shell.
# Otherwise execute PHP's built-in interative shell (`php -a`).
#
if which psysh > /dev/null 2>&1 && [[ -f /etc/psysh.php ]]; then
  psysh --cwd /app --config /etc/psysh.php;
else
  php -a;
fi
