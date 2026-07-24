#!/bin/sh
# php-free so the service suite runs in the pure base image: record one start
# line, then idle so the monitor sees a live process.

echo "$1" >> "/tmp/$1.out"

while true; do sleep 1; done
