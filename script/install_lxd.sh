#!/bin/bash

echo "Install LXC and LXD"
sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable -y
sudo add-apt-repository ppa:ubuntu-lxc/lxc-stable -y
sudo apt-get update
sudo apt-get install lxd lxc -y
echo "Install LXC and LXD done"

# add user to lxd group
sudo usermod -aG lxd $(whoami)
source ~/.bashrc

# TODO: replace this using LXC build script 
# create gpu lxd image
# variables
CONTAINER=cuda
EXPORT_NAME=ub1604_cuda8

echo "Build LXC GPU image"
lxd init --auto \
    --storage-backend dir \
    --network-address 0.0.0.0 \
    --network-port 8443

lxc network create lxdbr0
lxc network attach-profile lxdbr0 default eth0

lxc launch ubuntu:16.04 $CONTAINER
lxc exec $CONTAINER -- dhclient eth0
lxc exec $CONTAINER -- wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
lxc exec $CONTAINER -- dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
lxc exec $CONTAINER -- apt-get update
lxc exec $CONTAINER -- apt-get install cuda-demo-suite-8-0 --no-install-recommends -y
echo 'Build LXC GPU image done'

# add gpu config to image
lxc config device add $CONTAINER gpu gpu
lxc exec $CONTAINER -- echo "LXC GPU info"
lxc exec $CONTAINER -- nvidia-smi

# export image 
echo "Create LXC GPU image template ${EXPORT_NAME}"
lxc stop $CONTAINER
lxc publish $CONTAINER --alias $EXPORT_NAME
echo "Create LXC GPU image template: ${EXPORT_NAME} done"

# clean up
lxc delete $CONTAINER
