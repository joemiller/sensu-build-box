#!/bin/bash
 
# Usage: ./deploy.sh [host]
 
host="$1"
if [ -z "$host" ]; then
    echo "Usage: $0 host"
    exit 1
fi
 
# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null

rsync -a -v -z --delete-after -e "ssh -o 'StrictHostKeyChecking no'" \
    .   $host:chef
