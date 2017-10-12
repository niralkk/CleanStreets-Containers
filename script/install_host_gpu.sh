#!/bin/bash

echo "Install CUDA8.0 support for Host"
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda-8-0

echo "Install CUDA8.0 done"
echo "GPU info"
nvidia-smi