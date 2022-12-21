#!/bin/bash -ex
set -ex;
source /opt/build-scripts/common.sh;

apt-get update;

# Add NodeSource repository for NodeJS
curl -1fsSL https://deb.nodesource.com/setup_$NODEVS.x | bash;
apt-get install -y --no-install-recommends gettext nodejs;
npm install --global yarn;

#
# Configure NPM for global binaries
#
npm config  --global set cache /var/cache/npm;

#
# Install framework CLI utilities
#
npm install --global @angular/cli;
npm install --global laravel-mix-cli;
npm install --global react-cli;
npm install --global @symfony/webpack-encore;
npm install --global @vue/cli;

apt-get autoremove --purge;
