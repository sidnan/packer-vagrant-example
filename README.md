packer-vagrant-example
======================

Example Packer template to create Vagrant box


This repo contains example template to create ubuntu vagrant box using Packer.


# This is helpful to know

* Packer basics to create a vagrant box


# Used

* [Packer v0.5.2](http://www.packer.io/docs)
* [Vagrant v1.3.5](https://docs.vagrantup.com/v2/getting-started/)


# Technology choice

Vagrant can be used to create vagrant box, but it involves a lot of manual intervention. 

Packer on the other hand automates the box creation. It has the various options like memory size, disk space allocation, setting up tools, and so forth. These options provide fast development, maintainability, portability, testability of boxes. Packer caches (/packer_cache) a lot of details related to the box, which makes the subsequent building faster.

In the case of the Vagrant post-processor, it takes an artifact from a builder and transforms it into a Vagrant box file.

Packer has a single configuration file (json format) to setup for different virtualization product (like vmware player, virtual box, etc.). It prepare the boxes, in parallel, for all the specified products; this save time. This is helpful, if you got offshore people who are authorized to use different products in there dev environment.


# More about this project

This script builds for virtualbox and then exports it into vagrant. Packer has the option to build for multiple virtual players (like vmware player, etc.) either concurrently or sequentially.

The http directory contains a preseed.cfg file that is necessary to set up Ubuntu. 

The scripts directory has

* base.sh => install some basic tools like java, curl, wget
* vmtools.sh => installs basic tools
* vagrant.sh => setup vagrant ssh key for remote access
* provisioner.sh => install somemore softwares (If user pass "provisionerless" this does not install anything)
* cleanup.sh => clean the temps


# Packer lifecycle

1. Get the OS image specified in the "variable" block
2. Prepare the box for vagrant based on "builder" block
3. Set the box with defaults tools, software based on the "Provisioner" block
4. "post-processors" block - output the box to the path specified


# Steps to prepare box

1. packer build ubuntu.json