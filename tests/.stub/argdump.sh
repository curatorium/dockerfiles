#!/bin/sh
# Records every arg after the service name so tests can assert glob-safety.

name="$1"; shift
printf '%s' "$*" > "/tmp/$name.args"

while true; do sleep 1; done
