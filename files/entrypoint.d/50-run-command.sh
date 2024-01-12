#!/bin/bash

#
# If a command was specified then execute it & exit.
COMMAND="$1";
if [[ ! -z "$COMMAND" ]]; then
  sh -c "$COMMAND";
  exit;
fi
