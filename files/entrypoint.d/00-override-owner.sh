#!/bin/bash

#
# Setup www-data to run as the owner & group of the work_dir
OWNER_GROUP="$(stat -c "%g" .)";
OWNER_USER="$(stat -c "%u" .)";
if [[ "$OWNER_USER" != "0" ]] && [[ "$OWNER_GROUP" != "0" ]]; then
  groupmod -g "$OWNER_GROUP" www-data;
  usermod -u "$OWNER_USER" -g "$OWNER_GROUP" www-data;
fi
