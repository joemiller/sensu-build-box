#!/bin/sh

chef_solo='/opt/opscode/bin/chef-solo'

if ! which curl >/dev/null; then
    apt-get -y install curl
fi

if ! which git >/dev/null; then
    apt-get -y install git
fi

if ! which ruby >/dev/null; then
    apt-get -y install ruby1.9.1
fi

if [ ! -x "$chef_solo" ]; then
    curl -L http://www.opscode.com/chef/install.sh | bash
fi

# gem install librarian ?
# git clone ... ?
# cd chef && librarian-chef update


