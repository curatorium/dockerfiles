#!/bin/bash -ex
set -ex;
source /opt/build-scripts/common.sh;

apt-get update;

# Run installer for starship prompt manager
curl -1fsSL https://starship.rs/install.sh | sh -s -- --yes;

sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' /etc/dpkg/dpkg.cfg.d/excludes

apt-get install -y --no-install-recommends																		\
		bash-completion																														\
		cron																																			\
		git																																				\
		inetutils-ping																														\
		jq																																				\
		less																																			\
		man																																				\
		manpages-posix																														\
		mysql-client																															\
		nano																																			\
		netcat																																		\
		openssh-client																														\
		redis-tools																																\
		telnet																																		\
    tmux																																			\
		vim																																				\
																																							\
		php$PHPVS-phpdbg																													\
		php$PHPVS-xdebug																													\
		php$PHPVS-yaml																														\
;
phpdismod	pcov xdebug;

composer global bin psysh											require psy/psysh:@stable;
composer global bin symfony										require symfony/var-dumper;

apt-get autoremove --purge;
