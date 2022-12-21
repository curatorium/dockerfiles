#!/bin/bash -ex
#set -ex;
source /opt/build-scripts/common.sh;

apt-get update;

# Setting www-data to match our own XID for development use.
groupmod -g $WWW_USER_ID www-data;
usermod -u $WWW_USER_ID -g $WWW_GROUP_ID www-data;

# Prerequisites
apt-get install -y --no-install-recommends																		\
	ca-certificates																															\
	curl																																				\
	gnupg																																				\
	tini																																				\
	unzip																																				\
;

mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

#
# Installing Ondřej Surý's  debian repository for PHP packages
# @see https://launchpad.net/~ondrej/+archive/ubuntu/php/+packages
#
__apt_add_repo ondrej-php "http://ppa.launchpad.net/ondrej/php/ubuntu focal main" 4F4EA0AAE5267A6C

apt-get install -y --no-install-recommends																		\
		gifsicle																																	\
		imagemagick																																\
		jpegoptim																																	\
		optipng																																		\
		pngquant																																	\
																																							\
		php$PHPVS-bcmath																													\
		php$PHPVS-cli																															\
		php$PHPVS-common																													\
		php$PHPVS-curl																														\
		php$PHPVS-gd																															\
		php$PHPVS-imagick																													\
		php$PHPVS-intl																														\
		php$PHPVS-mbstring																												\
		php$PHPVS-memcached																												\
		php$PHPVS-mongodb																													\
		php$PHPVS-mysql																														\
		php$PHPVS-opcache																													\
		php$PHPVS-pgsql																														\
		php$PHPVS-readline																												\
		php$PHPVS-redis																														\
		php$PHPVS-sqlite																													\
		php$PHPVS-xml																															\
		php$PHPVS-zip																															\
;

if [[ "$PHPVS" < "8.0" ]]; then
	apt-get install -y --no-install-recommends																	\
			php$PHPVS-apcu																													\
			php$PHPVS-http																													\
			php$PHPVS-propro																												\
			php$PHPVS-raphf																													\
	;
fi


#
# Installing Composer
#
if [[ ! "$PHPVS" < "7.4" ]]; then
  curl -1fsSL https://getcomposer.org/installer | php -- --2.2 --install-dir=/usr/local/bin --filename=composer
else
  curl -1fsSL https://getcomposer.org/installer | php -- --1   --install-dir=/usr/local/bin --filename=composer
fi

apt-get autoremove --purge;
