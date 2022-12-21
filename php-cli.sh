#!/bin/bash -ex

set -ex;

source common.sh;

VS=$1; shift;

nrn-add-packages																															\
	gifsicle																																		\
	imagemagick																																	\
	jpegoptim																																		\
	optipng																																			\
	pngquant																																		\
																																							\
	php$VS-bcmath																																\
	php$VS-cli																																	\
	php$VS-gd																																		\
	php$VS-mysql																																\
	php$VS-pgsql																																\
	php$VS-sqlite																																\
																																							\
	php$VS-imagick																															\
	php$VS-memcached																														\
	php$VS-mongodb																															\
	php$VS-redis																																\
;
phpenmod																																			\
  bcmath																																			\
  imagick																																			\
  gd																																					\
  memcached																																		\
  mongodb																																			\
  mysql																																				\
  pgsql																																				\
  redis																																				\
  sqlite																																			\
;
