ARG BASE
FROM $BASE

COPY tools/phive		/usr/local/bin/
RUN  chmod +x			/usr/local/bin/*

ARG VS
RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf														\
 && apt-get update																										\
 && apt-get install -y --no-install-recommends																			\
		gifsicle																										\
		imagemagick																										\
		jpegoptim																										\
		optipng																											\
		php$VS-bcmath																									\
		php$VS-intl																										\
		php$VS-gd																										\
		php$VS-imagick																									\
		php$VS-memcached																								\
		php$VS-mongodb																									\
		php$VS-mysql																									\
		php$VS-pgsql																									\
		php$VS-redis																									\
		php$VS-sqlite																									\
		pngquant																										\
 && apt-get autoremove --purge && apt-get clean																			\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*														\
;

RUN phpenmod																											\
		bcmath																											\
		intl																											\
		gd																												\
		imagick																											\
		memcached																										\
		mongodb																											\
		pdo_mysql																										\
		pdo_pgsql																										\
		redis																											\
		pdo_sqlite																										\
;

RUN phive --no-progress install -g --trust-gpg-keys 9D8A98B29B2D5D79 phar-io/phive@0.13.5								\
 && phive --no-progress install -g --trust-gpg-keys CBB3D576F2A0946F composer											\
;

WORKDIR /app

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
