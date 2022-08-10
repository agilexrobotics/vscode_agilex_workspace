#!/bin/bash
set -e

chmod +x build.sh
chmod +x test.sh

# Install ydlidar SDK for ydlidar package
git clone https://ghproxy.com/https://github.com/YDLIDAR/YDLidar-SDK.git
mkdir -p YDLidar-SDK/build
cd YDLidar-SDK/build &&\
cmake ..&&\
make &&\
sudo make install &&\
cd .. &&\
pip install . &&\
cd .. && rm -rf YDLidar-SDK 

# Init the workspace
catkin init --reset

vcs import < src/ros.repos src
sudo apt-get update
rosdepc update
rosdepc install --from-paths src --ignore-src -y
