#!/bin/bash
set -e

# Install ydlidar SDK for ydlidar package
git clone https://github.com/YDLIDAR/YDLidar-SDK.git
mkdir -p YDLidar-SDK/build
cd YDLidar-SDK/build &&\
cmake ..&&\
make &&\
make install &&\
cd .. &&\
pip install . &&\
cd .. && rm -r YDLidar-SDK 

vcs import < src/ros2.repos src
sudo apt-get update
rosdep update
rosdep install --from-paths src --ignore-src -y
