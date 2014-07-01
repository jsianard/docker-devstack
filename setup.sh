#!/bin/bash

set -e

# $1 - username
# $2 - password
function add_user() {
	echo "creating user: ${1}"
	if ! id -u "$1" >/dev/null 2>&1; then
	    echo "Adding $1 user"
	    useradd -G root -m "$1" -s /bin/bash
	    passwd "$1" <<_EOF_
"$2"
"$2"
_EOF_
	fi
}


# apt-get install packages
apt-get update
apt-get install -y gcc git python-pip python-dev sudo libyaml-dev
pip install PyYaml

# prep for devstack
STACK_PASSWORD=`date +%s | sha256sum | base64 | head -c 10 ; echo`
add_user stack ${STACK_PASSWORD}
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
