#!/usr/bin/env bash

apt-get update

# Libraries for opengl in the container
apt-get install -y -qq --no-install-recommends \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \

# Builder dependencies installation
apt-get install -qq -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    vim \
    libssl-dev \
    wget \
    libusb-1.0-0-dev \
    pkg-config \
    libgtk-3-dev \
    libglfw3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \    
    curl \	
    libusb-1.0-0 \
    udev \
    apt-transport-https \
    ca-certificates \
    curl \
    swig \
    python3-pip \
    software-properties-common \
    libpulse-dev \
    portaudio19-dev \
    espeak \
    alsa-utils \
    bash-completion \
    gdb

# Clean up
apt-get autoremove -y 
apt-get clean -y 
rm -rf /var/lib/apt/lists/*