#!/bin/bash -ex
set -ex;

PHPVS=$1;   shift;
NODEVS=$1;  shift;
X_ARCH=$1;  shift;
X_UID=$1;   shift;

WWW_USER_ID=`echo $X_UID | awk -F: '{print $1}'`;
WWW_GROUP_ID=`echo $X_UID | awk -F: '{print $2}'`;

#
# Fetch a binary from a URL & make it executable.
#
function __bin_add() {
  name=$1; shift;
  url=$1; shift;

  curl -1fsSL $url -o /usr/local/bin/$name;
  chmod +x /usr/local/bin/$name;
}

#
# Install a repository from a debian URL or an installer script
#
# $name repository name
# $url  debian repository or repo installer script
# $key  repository GPG key fingerprint
#
function __apt_add_repo() {
  name=$1; shift;
  url=$1; shift;
  key=$1;

	echo "deb $url" > /etc/apt/sources.list.d/$name.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key;
	apt-get update;
}
