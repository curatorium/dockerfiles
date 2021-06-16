#
#	Docker build instructions via Dockerfile
#

neurony/php:		neurony/php\:7.2		neurony/php\:7.3		neurony/php\:7.4		neurony/php\:8.0
neurony/php\:7.2:	neurony/php-cli\:7.2	neurony/php-fpm\:7.2	neurony/php-qa\:7.2		neurony/php-dev\:7.2
neurony/php\:7.3:	neurony/php-cli\:7.3	neurony/php-fpm\:7.3	neurony/php-qa\:7.3		neurony/php-dev\:7.3
neurony/php\:7.4:	neurony/php-cli\:7.4	neurony/php-fpm\:7.4	neurony/php-qa\:7.4		neurony/php-dev\:7.4
neurony/php\:8.0:	neurony/php-cli\:8.0	neurony/php-fpm\:8.0	neurony/php-qa\:8.0		neurony/php-dev\:8.0

neurony/php-cli\:%: php.Dockerfile tools/phive
	docker build	--file $<																							\
					--tag $@																							\
					--build-arg VS=$*																					\
					--build-arg "BASE=phpdockerio/php$(strip $(subst .,, $*))-cli"										\
					.																									\
	;
neurony/php-fpm\:%: php.Dockerfile tools/phive
	docker build	--file $<																							\
					--tag $@																							\
					--build-arg VS=$*																					\
					--build-arg "BASE=phpdockerio/php$(strip $(subst .,, $*))-fpm"										\
					.																									\
	;
neurony/php-qa\:%: php-qa.Dockerfile neurony/php-fpm\:% tools/local-php-security-checker tools/wait-until
	docker build	--file $<																							\
					--tag $@																							\
					--build-arg VS=$*																					\
					--build-arg "BASE=$(word 2, $^)"																	\
					.																									\
	;
neurony/php-dev\:%: php-dev.Dockerfile neurony/php-qa\:% tools/php-serve
	docker build	--file $<																							\
					--tag $@																							\
					--build-arg VS=$*																					\
					--build-arg "BASE=$(word 2, $^)"																	\
					.																									\
	;


#
#	Build all & push all instructions
#

build-all:	neurony/php

push-all:
	docker push --all-tags neurony/php-cli;
	docker push --all-tags neurony/php-fpm;
	docker push --all-tags neurony/php-qa;
	docker push --all-tags neurony/php-dev;


#
# External dependencies
#

tools/phive:
	curl -sLf -o $@	 https://github.com/phar-io/phive/releases/download/0.14.5/phive-0.14.5.phar;
	curl -sLf -o $@.asc https://github.com/phar-io/phive/releases/download/0.14.5/phive-0.14.5.phar.asc;
	gpg --keyserver pool.sks-keyservers.net --recv-keys 0x9D8A98B29B2D5D79;
	gpg --verify $@.asc $@;
tools/local-php-security-checker:
	curl -sLf -o $@ "https://github.com/fabpot/local-php-security-checker//releases/download/v1.0.0/local-php-security-checker_1.0.0_linux_amd64";
tools/wait-until:
	curl -sLf https://raw.githubusercontent.com/nickjj/wait-until/v0.2.0/wait-until -o $@;
