# vagrant-aws-operation-stack

(c) Andre Lohmann (and others) 2019

## Maintainer Contact
 * Andre Lohmann
   <lohmann.andre (at) gmail (dot) com>

## content

This vagrant machine deploys an operations stack on aws.

The stack consists of a gitlab server with mattermost, a gitlab runner and an ses account for email transactions.

## Prequesites

### VirtualBox

  * install the latest virtualbox from oracle repositories (https://www.virtualbox.org/wiki/Downloads)
  * if you are on a linux distro, follow the instructions to add the oracle repo
  * install the latest Oracle VM VirtualBox Extension Pack

### Vagrant

#### cli

  * Install the latest vagrant (https://www.vagrantup.com/downloads.html)

#### plugins

the vagrant machines depends on two vagrant plugins.

```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-sshfs
```

these pluins should get installed automatically on a "vagrant up", if that fails anyways, please manually install the plugins by entering the commands

##### Windows

If you are on Microsoft Window, you need to install openssh.

https://docs.microsoft.com/de-de/windows-server/administration/openssh/openssh_install_firstuse

### AWS

  * Create IAM User (with AdminAccess permissions preferred)
  * fetch Programmatic Access Credentials
  * fetch IAM User ARN
  * Create a Route53 Public Zone for showcase domain
  * Subscribe to the latest [Minimal Ubuntu 18.04 LTS - Bionic](https://aws.amazon.com/marketplace/pp/B07J5RRYGN?qid=1573884375147&sr=0-4&ref_=srh_res_product_title)
  * Select latest software version, your region and copy ami-id

## usage

### upstart

  * clone the repo and change to the directory
  * copy ansible_vagrant/custom_vars.yml.example to ansible_vagrant/custom_vars.yml and set your credentials
  * run the machine

```
vagrant up
```
