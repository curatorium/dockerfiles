#
#	Docker build instructions via Dockerfile
#

neurony/php:		neurony/php\:7.2		neurony/php\:7.3		neurony/php\:7.4		neurony/php\:8.0

neurony/php\:7.2:	neurony/php-cli\:7.2	neurony/php-fpm\:7.2	neurony/php-qa\:7.2		neurony/php-dev\:7.2
neurony/php\:7.3:	neurony/php-cli\:7.3	neurony/php-fpm\:7.3	neurony/php-qa\:7.3		neurony/php-dev\:7.3
neurony/php\:7.4:	neurony/php-cli\:7.4	neurony/php-fpm\:7.4	neurony/php-qa\:7.4		neurony/php-dev\:7.4
neurony/php\:8.0:	neurony/php-cli\:8.0	neurony/php-fpm\:8.0	neurony/php-qa\:8.0		neurony/php-dev\:8.0

neurony/php-cli:	neurony/php-cli\:7.2	neurony/php-cli\:7.3	neurony/php-cli\:7.4	neurony/php-cli\:8.0
neurony/php-fpm:	neurony/php-fpm\:7.2	neurony/php-fpm\:7.3	neurony/php-fpm\:7.4	neurony/php-fpm\:8.0
neurony/php-qa:		neurony/php-qa\:7.2		neurony/php-qa\:7.3		neurony/php-qa\:7.4		neurony/php-qa\:8.0
neurony/php-dev:	neurony/php-dev\:7.2	neurony/php-dev\:7.3	neurony/php-dev\:7.4	neurony/php-dev\:8.0

neurony/php-cli\:%: php.Dockerfile
	docker build	--file $<																							\
					--tag $@																							\
					--build-arg VS=$*																					\
					--build-arg "BASE=phpdockerio/php$(strip $(subst .,, $*))-cli"										\
					.																									\
	;
neurony/php-fpm\:%: php.Dockerfile
	docker build	--file $<																							\
					--tag $@																							\
					--build-arg VS=$*																					\
					--build-arg "BASE=phpdockerio/php$(strip $(subst .,, $*))-fpm"										\
					.																									\
	;
neurony/php-qa\:%: php-qa.Dockerfile neurony/php-fpm\:%
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

all:	neurony/php

push-all:
	docker push --all-tags neurony/php-cli;
	docker push --all-tags neurony/php-fpm;
	docker push --all-tags neurony/php-qa;
	docker push --all-tags neurony/php-dev;
