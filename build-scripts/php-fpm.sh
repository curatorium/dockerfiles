#!/bin/bash -ex
set -ex;
source /opt/build-scripts/common.sh;

apt-get update;
apt-get install -y --no-install-recommends php$PHPVS-fpm;

apt-get autoremove --purge;
