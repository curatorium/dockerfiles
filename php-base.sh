#!/bin/bash -ex

set -ex;

source common.sh;

VS=$1; shift;

nrn-add-packages																															\
	ca-certificates																															\
	curl																																				\
	gnupg																																				\
	unzip																																				\
;

mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

nrn-add-repo ondrej-php http://ppa.launchpad.net/ondrej/php/ubuntu 4F4EA0AAE5267A6C

nrn-add-packages																															\
		php$VS-common																															\
		php$VS-curl																																\
		php$VS-intl																																\
		php$VS-mbstring																														\
		php$VS-opcache																														\
		php$VS-readline																														\
		php$VS-xml																																\
		php$VS-zip																																\
;
phpenmod																																			\
		curl																																			\
		intl																																			\
		mbstring																																	\
		opcache																																		\
		readline																																	\
		xml																																				\
		zip																																				\
;

if [[ "$VS" < "8.0" ]]; then
	nrn-add-packages																														\
			php$VS-apcu																															\
			php$VS-http																															\
			php$VS-propro																														\
			php$VS-raphf																														\
	;
	phpenmod																																		\
		apcu																																			\
		http																																			\
		propro																																		\
		raphf																																			\
	;
fi