#!/bin/bash
set -e

chmod +x build.sh
chmod +x test.sh

vcs import < src/ros2.repos src
sudo apt-get update
rosdep update
rosdep install --from-paths src --ignore-src -y
