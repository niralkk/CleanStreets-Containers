# LXD gpu support

## Install GPU on host

Ubuntu 14.04

```bash
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1404_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda-8-0
```

Ubuntu 16.04:

```bash
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda-8-0
```

After install use  ```nvidia-smi``` check driver version

[host_nvidia_smi]: img/host_nvidia_smi.png

![host_nvidia_smi]

## Install LXD

Install LXD

```bash
sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable -y
sudo apt-get update
sudo apt-get install lxd
```

Install LXC

```bash
sudo add-apt-repository ppa:ubuntu-lxc/lxc-stable -y
sudo apt-get update
sudo apt-get install lxc
```

Add yourself to lxd account to avoid using root privilege

```bash
sudo usermod -aG lxd $(whoami)
```

### Create a GPU support container

First time to start lxd container 
Basically, just type enter and use default setting

```bash
sudo lxd init
```

Create a GPU support container image

Pull ubuntu 16.04 as based image

```bash
lxc launch ubuntu:16.04 c1
```

Install cuda toolkit 8.0 on container

```bash
lxc exec c1 -- wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
lxc exec c1 -- dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
lxc exec c1 -- apt-get update
lxc exec c1 -- apt-get install cuda-demo-suite-8-0 --no-install-recommends
```

Add GPU to container

```bash
lxc config device add c1 gpu gpu
```

Use nvidia-smi command to check container can correct get gpu
If to reponse library no match see treouble shooting 1

```bash
lxc exec c1 -- nvidia-smi
```

#### Publish container image

Stop the running containner

```bash
lxc stop c1
```

Publish GPU support image

```bash
lxc publish c1 --alias ub1604_cuda8
```

## Trouble shooting

1. ```lxc exec c1 -- nvidia-smi``` said library not match

   This happend if host add 3rd party ppa for gpu driver.
   But in previous setting containter used nvidia cuda repo provide gpu driver.

2. If reboot is not allowed, tried to unload nvidia driver

    ```bash
    sudo rmmod nvidia
    ```

    Check nvidia module depdency ```lsmod | grep nvidia``` , and use ```rmmod``` step by step