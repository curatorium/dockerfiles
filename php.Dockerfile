ARG BASE
FROM $BASE

ARG VS
RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf														\
 && apt-get update																										\
 && apt-get install -y --no-install-recommends																			\
		gifsicle																										\
		imagemagick																										\
		jpegoptim																										\
		optipng																											\
		php$VS-bcmath																									\
		php$VS-imagick																									\
		php$VS-intl																										\
		php$VS-gd																										\
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
		pdo_sqlite																										\
		redis																											\
;

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
ADD https://phar.io/releases/phive.phar /usr/local/bin/phive
RUN chmod +x /usr/local/bin/*

WORKDIR /app

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
