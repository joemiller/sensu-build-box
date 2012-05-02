sensu-build-box
===============

This repo contains scripts/files for configuring the sensu-build server via
Chef.

It is currently specific to Ubuntu (tested on 12.04).

It utilizes standard cookbooks from http://community.opscode.com as well as
these custom cookbooks:

* https://github.com/joemiller/chef-sensu_repo	- Sets up yum and apt repos and
  accompanying tools (gnupg, freight, creatrepo, etc)
* https://github.com/joemiller/chef-sensu_jenkins - Sets up Jenkins with
  Apache2 frontend (SSL vhost only)

Install
-------

```
git clone git://github.com/joemiller/sensu-build-box.git
cd sensu-build-box
sudo sh bootstrap.sh
```

1-time Manual Install Steps
---------------------------

There are some manual steps required that are not performed by the Chef recipes.
They only need to be run once.

1. Install SSL key/cert for apache2.
2. Configure S3 keys for `repo` user (`s3cmd`)

### SSL key/cert

After running chef-solo.

copy certs into: `/etc/apache2/ssl/ssl-cert-snakeoil.pem`
copy key into: `/etc/apache2/ssl/ssl-cert-snakeoil.key`

These can be overriden by the attributes:

```
node.default.sensu_jenkins.ssl_cert_file = "/etc/apache2/ssl/ssl-cert-snakeoil.pem"
node.default.sensu_jenkins.ssl_key_file = "/etc/apache2/ssl/ssl-cert-snakeoil.key"
```

### S3 keys (s3cmd)

```
sudo -u repo -i s3cmd --configure
```

Usage
-----

### Running chef-solo

TODO

### Adding .deb packages

This command will add one or more .deb's to the apt repo, call `freight` to 
process them, then call the `/repo/scripts/sync_to_s3.rb` script to sync
the `/repo/html/` tree to S3.

```
sudo -u repo -H /repo/scripts/apt_add_debs.rb sensu_0.9.5-36_i386.deb sensu_0.9.5-36_amd64.deb
```

(`-H` is important.)

### Adding .rpm packages

This command will add one or more .rpm's to the yum repos, sign each of them
using `rpmbuild`, update yum metadata with `createrepo`, then call the 
`/repo/scripts/sync_to_s3.rb` script to sync the `/repo/html/` tree to S3.

```
sudo -u repo -H /repo/scripts/yum_add_rpms.rb sensu-0.9.5-36.i386.rpm sensu-0.9.5-36.x86_64.rpm
```