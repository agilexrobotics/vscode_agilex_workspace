# See https://hub.docker.com/_/ros for more information
FROM ros:foxy as dev

ARG USE_CHINESE_MIRROR

# For Chinese mainland user
RUN if [ $USE_CHINESE_MIRROR -eq "true" ]; then source ../switch_to_chinese_source.sh; fi

ARG WORKSPACE
# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "false" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

RUN gpasswd --add vscode root && gpasswd --add vscode tty && gpasswd --add vscode tty

ENV DEBIAN_FRONTEND=noninteractive

# For Chinese mainland user.
# RUN  sed -i "s/ports.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
# RUN  sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
    # Libraries for opengl in the container
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
    python3-pip \
    software-properties-common \
    libpulse-dev \
    portaudio19-dev \
    espeak \
    alsa-utils \
    bash-completion \
    gdb \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*


# set default audio device
RUN echo "defaults.ctl.card 2" >> /etc/asound.conf
RUN echo "defaults.pcm.card 2" >> /etc/asound.conf
RUN echo "defaults.timer.card 2" >> /etc/asound.conf

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /etc/bash.bashrc
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> /etc/bash.bashrc

ENV DEBIAN_FRONTEND=dialog

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