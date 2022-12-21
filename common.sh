#!/bin/bash -ex

function nrn-add-repo() {
	file=$1; shift;
	url=$1; shift;
	key=$1; shift;
	echo "deb $url focal main" > /etc/apt/sources.list.d/$file.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key;
}

function nrn-add-packages() {
	apt-get update;
	apt-get install -y --no-install-recommends $@;
	apt-get autoremove --purge;
	apt-get clean;
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*;
}
