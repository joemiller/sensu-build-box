#!/bin/sh

chef_solo='/opt/opscode/bin/chef-solo'
debs_needed="curl git ruby rubygems make gcc"

## --- main ---

## -- install any distro pkgs we need
debs_to_install=''

for deb in $debs_needed; do
    if ! dpkg --status $deb >/dev/null 2>&1; then
        debs_to_install=$(echo $debs_to_install $deb)
    fi
done

if [ ! -z "$debs_to_install" ]; then
    apt-get -y install $debs_to_install
fi

## -- install chef omnibus package if not installed
if [ ! -x "$chef_solo" ]; then
    curl -L http://www.opscode.com/chef/install.sh | bash
fi

# gem install librarian ?
# git clone ... ?
# cd chef && librarian-chef update

if ! which librarian-chef >/dev/null; then
    gem install librarian --no-rdoc --no-ri
fi

cd chef && librarian-chef update

# do chef stuff TODO
