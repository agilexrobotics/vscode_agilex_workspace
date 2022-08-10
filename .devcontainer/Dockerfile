
# See https://hub.docker.com/r/althack/ros for more information
FROM althack/ros:melodic-gazebo as dev

ARG USE_CHINESE_MIRROR

ARG WORKSPACE

COPY library-scripts/*.sh /tmp/library-scripts/

# For Chinese mainland user
RUN if [ "${USE_CHINESE_MIRROR}" = "true" ]; \
    then \
    /bin/bash /tmp/library-scripts/switch_to_chinese_mirrors.sh; \
    fi

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    # Libraries for opengl in the container
    && apt-get install -y --no-install-recommends \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
    # Builder dependencies installation
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
    python-pip \
    software-properties-common \
    libpulse-dev \
    portaudio19-dev \
    espeak \
    alsa-utils \
    bash-completion \
    gdb \
    python-catkin-tools \
    # vcstool support
    && apt-get install -y python-vcstool \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# set default audio device
RUN echo "defaults.ctl.card 2" >> /etc/asound.conf
RUN echo "defaults.pcm.card 2" >> /etc/asound.conf
RUN echo "defaults.timer.card 2" >> /etc/asound.conf


RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /etc/bash.bashrc
RUN echo "if [ -f ${WORKSPACE}/devel/setup.bash ]; then source ${WORKSPACE}/devel/setup.bash; fi" >> /etc/bash.bashrc
ENV DEBIAN_FRONTEND=

# ** [可选] 取消注释安装其他组件 **
#
# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#    && apt-get -y install --no-install-recommends <your-package-list-here> \
#    #
#    # Clean up
#    && apt-get autoremove -y \
#    && apt-get clean -y \
#    && rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=dialog

# 配置自动 source