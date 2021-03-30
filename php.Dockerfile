ARG BASE
FROM $BASE

COPY tools/phive		/usr/local/bin/

ARG VS
RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf														\
 && apt-get update																										\
 && apt-get install -y --no-install-recommends																			\
		php$VS-bcmath																									\
		php$VS-intl																										\
		php$VS-gd																										\
		php$VS-memcached																								\
		php$VS-mongodb    																								\
		php$VS-mysql																									\
		php$VS-pgsql																									\
		php$VS-redis																									\
		php$VS-sqlite																									\
 && apt-get autoremove --purge																							\
 && apt-get clean																										\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*														\
 && chmod +x /usr/local/bin/*																							\
 && phpenmod																											\
		bcmath																											\
		intl																											\
		gd																												\
		memcached																										\
		mongodb																											\
		pdo_mysql																										\
		pdo_pgsql																										\
		redis																											\
		pdo_sqlite																										\
 && phive --no-progress install -g --trust-gpg-keys 9D8A98B29B2D5D79 phar-io/phive										\
 && phive --no-progress install -g --trust-gpg-keys CBB3D576F2A0946F composer											\
;

WORKDIR /app

LABEL maintainer="Mihai Stancu <mihai.stancu@neurony.ro>"
