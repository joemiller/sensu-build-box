Sensu Build Box
===============

Purpose
-------

The sensu build box is a physical dedicated server intended to run the various
Sensu package build and test suites that utilize Vagrant + VirtualBox for VMs.

Box services
------------

* Yum and Apt repo management.

	The Yum and Apt repos and scripts will reside on this box, but they will not 
	be served from here, instead they will be sync'd to S3.


- 


--------------------


One-time setup / prep
=====================

Create GPG key
--------------
We need a GPG key for signing the Apt repo and for signing RPM's.

`sudo apt-get -y install gnupg`

Create the key:

```
cat <<EOF | gpg --gen-key --batch
 %echo generating Sensu package signing key
 Key-Type: RSA
 Key-Length: 2048
 Name-Real: Sensu Package Maintainer
 Name-Email: sensu@sonian.com
 Expire-Date: 0
 %pubring sensu-keyring.pub
 %secring sensu-keyring.sec
 %commit
 %echo Done
EOF
```

TODO: decide on details about key - management, name, email.


Setup yum repo
--------------

```
sudo apt-get -y install rpm createrepo

mkdir /repo/html/yum
mkdir -p /repo/html/yum/el/5/x86_64
mkdir -p /repo/html/yum/el/5/i386

```

### adding rpm to yum repo

```
cp sensu-xxx.i386.rpm /repo/yum/el/5/i386/
cp sensu-xxx.i386.rpm /repo/yum/el/6/i386/

cp sensu-xxx.x86_64.rpm /repo/yum/el/5/x86_64/
cp sensu-xxx.x86_64.rpm /repo/yum/el/6/x86_64/

createrepo -d -s sha1 /repo/yum/el/5/i386/
createrepo -d -s sha1 /repo/yum/el/5/x86_64/
createrepo -d -s sha1 /repo/yum/el/6/i386/
createrepo -d -s sha1 /repo/yum/el/6/x86_64/
```


Setup Apt repo
--------------

```
git clone git@github.com:rcrowley/freight
cd freight && make && sudo make install

mkdir /repo/freight
mkdir /repo/html/apt

cat <<EOF >/usr/local/etc/freight.conf
VARLIB="/repo/freight"
VARCACHE="/repo/html/apt"

ORIGIN="Sensu"
LABEL="Sensu"
GPG="sensu@sonian.com"
EOF
```


-------------

SPECS

attributes:
- sensu_repo.base_dir = '/repo'
- sensu_repo.user = 'repo'

sensu_repo (default)
	- include_recipes:
		user, ::gpg, yum, apt, freight, scripts

sensu_repo::user
	- dir: #{base_dir}
	- user create '#{user}', homedir: #{base_dir}

sensu_repo::gpg
	- install gpg, create key for #{user}

sensu_repo::yum
	- pkg: createrepo
	- dir: /repo/html/yum

sensu_repo::apt
	- pkg: dpkg
	- dir: /repo/html/apt

sensu_repo::freight
	- dir: 
	- apt_repo rcrowley's repo
	- pkg: freight
	- file(template): freight.conf

sensu_repo::scripts
	- dir: /repo/scripts
	- install scripts 
		apt_add_file ?
		yum_add_file ?
		sync_to_s3

TODO
----
x	submit PR to upstream gpg repo
x	metadata: supports debian/ubuntu
x	how to point freight at different keyrings?
-	need a .repo file deployed in the yum area that people can d/l
- 	yum_add_files  script
-	apt_add_files	script
x	add 'noarch' dirs to yum el/5 and /6
-	setup DEFAULT_DISTRO for apt
x 	conver into more genral sensu-build-box git repo
