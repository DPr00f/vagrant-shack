# packer-vagrant-shack-box
An automated creation of a vagrantbox with virtualbox

# How to use Shack
make sure `shack` is executable

Type `chmod +x shack`

Install by typing `./shack install` and follow instructions

# Contents
The installation creates a configured box for Phalcon PHP with:

- nginx
- mariadb-server-10.0 (Global user and available from outside the box user: shack password: secret)
- PHP 5.6
- Composer
- Phalcon
- Phalcon Dev Tools
- MemcaheD
- Redis
- MongoDB
- Node
- Ruby

# Building the box
The box will run the following scripts:

- script/ubuntu/update.sh
- script/ubuntu/network.sh
- script/common/vagrant.sh
- script/common/virtualbox.sh
- script/common/motd.sh
- script/ubuntu/post-install.sh
- script/ubuntu/cleanup.sh

The **post-install.sh** script contains the installation for all the server goodies

There are currently 4 possible boxes to install:

- Ubuntu Server 14.10 64bit (512MB)
- Ubuntu Server 14.10 32bit (512MB)
- Ubuntu Server 14.10 64bit (2048MB)
- Ubuntu Server 14.10 32bit (2048MB)

**NOTE:** Please take in mind that we can change the box memory size on runtime using vagrant. 512MB is good if you want to serve the box using [atlas.hashicorp.com](http://atlas.hashicorp.com)


## The installation commands

To run the commands you need to be in the **templates** folder.

`cd packer-vagrant-shack-box/templates`

To install **Ubuntu Server 14.10 64bit (512MB)** type

`packer build -only=shack ubuntu.json`

To install **Ubuntu Server 14.10 32bit (512MB)** type

`packer build -only=shack32 ubuntu.json`

To install **Ubuntu Server 14.10 64bit (2048MB)** type

`packer build -only=shack-2048 ubuntu.json`

To install **Ubuntu Server 14.10 32bit (2048MB)** type

`packer build -only=shack32-2048 ubuntu.json`

To install **all boxes** type
`packer build ubuntu.json`