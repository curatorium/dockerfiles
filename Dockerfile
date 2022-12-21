#
# PHP-CLI
#
ARG			BASE
FROM		$BASE AS cli
ARG			NODEVS
ARG			PHPVS
ARG			X_ARCH
ARG			X_UID

ENV			TERM=linux
ENV			DEBIAN_FRONTEND=noninteractive
ENV			COMPOSER_ALLOW_SUPERUSER=1

COPY		build-scripts /opt/build-scripts
COPY        docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN			--mount=type=cache,target=/root/.composer/cache																\
			--mount=type=cache,target=/root/.config/composer/cache														\
			--mount=type=cache,target=/var/cache																		\
			--mount=type=tmpfs,destination=/var/lib/apt/lists															\
			--mount=type=tmpfs,destination=/var/tmp																		\
			--mount=type=tmpfs,destination=/usr/share/doc																\
			--mount=type=tmpfs,destination=/tmp																			\
			/opt/build-scripts/php-cli.sh $PHPVS $NODEVS $X_ARCH $X_UID

# tini handles PID=1 and reaps zombie processes
# @see https://github.com/krallin/tini
# @see https://github.com/krallin/tini/issues/8
ENTRYPOINT	["tini", "--"]
CMD			["docker-entrypoint"]

STOPSIGNAL	SIGTERM
WORKDIR		/app


#
# PHP-FPM
#
FROM		cli AS fpm
ARG			NODEVS
ARG			PHPVS
ARG			X_ARCH
ARG			X_UID

COPY        files/etc/init.d/php-fpm /etc/init.d/
RUN			--mount=type=cache,target=/root/.composer/cache																\
			--mount=type=cache,target=/root/.config/composer/cache														\
			--mount=type=cache,target=/var/cache																		\
			--mount=type=tmpfs,destination=/var/lib/apt/lists															\
			--mount=type=tmpfs,destination=/var/tmp																		\
			--mount=type=tmpfs,destination=/usr/share/doc																\
			--mount=type=tmpfs,destination=/tmp																			\
			/opt/build-scripts/php-fpm.sh $PHPVS $NODEVS $X_ARCH $X_UID

# PHP-FPM server
EXPOSE		9000


#
# PHP-QA
#
FROM		fpm AS qa
ARG			NODEVS
ARG			PHPVS
ARG			X_ARCH
ARG			X_UID

RUN			--mount=type=cache,target=/root/.composer/cache																\
			--mount=type=cache,target=/root/.config/composer/cache														\
			--mount=type=cache,target=/var/cache																		\
			--mount=type=tmpfs,destination=/var/lib/apt/lists															\
			--mount=type=tmpfs,destination=/var/tmp																		\
			--mount=type=tmpfs,destination=/usr/share/doc																\
			--mount=type=tmpfs,destination=/tmp																			\
			/opt/build-scripts/php-qa.sh $PHPVS $NODEVS $X_ARCH $X_UID


#
# Fullstack PHP + NodeJS
#
FROM		qa AS fs
ARG			NODEVS
ARG			PHPVS
ARG			X_ARCH
ARG			X_UID

ENV			PATH "$PATH:/opt/npm/bin"
RUN			--mount=type=cache,target=/root/.composer/cache																\
			--mount=type=cache,target=/root/.config/composer/cache														\
			--mount=type=cache,target=/var/cache																		\
			--mount=type=tmpfs,destination=/var/lib/apt/lists															\
			--mount=type=tmpfs,destination=/var/tmp																		\
			--mount=type=tmpfs,destination=/usr/share/doc																\
			--mount=type=tmpfs,destination=/tmp																			\
			/opt/build-scripts/php-fs.sh $PHPVS $NODEVS $X_ARCH $X_UID


#
# PHP-DEV
#
FROM		fs AS dev
ARG			NODEVS
ARG			PHPVS
ARG			X_ARCH
ARG			X_UID

COPY        files/etc/init.d/php-http /etc/init.d/
COPY        files/etc/init.d/var-dump /etc/init.d/
COPY        files/etc/psysh.php /etc/psysh.php
COPY        files/etc/starship.toml /etc/starship.toml
COPY		files/root/.bash* /root/
RUN			--mount=type=cache,target=/root/.composer/cache																\
			--mount=type=cache,target=/root/.config/composer/cache														\
			--mount=type=cache,target=/var/cache																		\
			--mount=type=tmpfs,destination=/var/lib/apt/lists															\
			--mount=type=tmpfs,destination=/var/tmp																		\
			--mount=type=tmpfs,destination=/usr/share/doc																\
			--mount=type=tmpfs,destination=/tmp																			\
			/opt/build-scripts/php-dev.sh $PHPVS $NODEVS $X_ARCH $X_UID

ENV			VAR_DUMPER_FORMAT server
ENV			STARSHIP_CONFIG /etc/starship.toml

# PHP-HTTP server
EXPOSE		80
# PHP-HTTP server (if HTTPs is available)
EXPOSE		443
# Symfony Dump Server @see https://symfony.com/doc/current/components/var_dumper.html#the-dump-server
EXPOSE		9912
