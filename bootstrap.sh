#!/bin/sh

chef_solo='/opt/opscode/bin/chef-solo'
debs_needed="curl git ruby rubygems make gcc"

## --- main ---

## -- install any distro pkgs we need
echo "==> Checking for missing dependencies.."
debs_to_install=''

for deb in $debs_needed; do
    if ! dpkg --status $deb >/dev/null 2>&1; then
        debs_to_install=$(echo $debs_to_install $deb)
    fi
done

if [ ! -z "$debs_to_install" ]; then
    echo "==> Installing missing dependencies: $debs_to_install"
    apt-get -y install $debs_to_install
fi

## -- install chef omnibus package if not installed
if [ ! -x "$chef_solo" ]; then
    echo "==> Chef not installed, installing the omnibus package"
    curl -L http://www.opscode.com/chef/install.sh | bash
fi

# gem install librarian ?
# git clone ... ?
# cd chef && librarian-chef update

if ! which librarian-chef >/dev/null; then
    echo "==> Librarian not installed, installing.."
    gem install librarian --no-rdoc --no-ri
fi

echo "==> Running 'librarian-chef update'"
cd chef && librarian-chef update
