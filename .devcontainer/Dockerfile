FROM ros:foxy as dev

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

# Builder dependencies installation
RUN apt-get update \
    && apt-get install -qq -y --no-install-recommends \
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
    software-properties-common \
    python3-pip \
    libpulse-dev \
    portaudio19-dev \
    espeak \
    alsa-utils \
    bash-completion \
    gdb \
    && rm -rf /var/lib/apt/lists/*

# RUN git clone https://github.com/YDLIDAR/YDLidar-SDK.git &&\
#     mkdir -p YDLidar-SDK/build && \
#     cd YDLidar-SDK/build &&\
#     cmake ..&&\
#     make &&\
#     make install &&\
#     cd .. &&\
#     pip install . &&\
#     cd .. && rm -r YDLidar-SDK 

RUN echo "source /opt/ros/foxy/setup.bash" >> /etc/bash.bashrc

FROM dev as nvidia

# libraries for opengl in the container
RUN apt-get update \
    && apt-get install -y -qq --no-install-recommends \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

# Env vars for the nvidia-container-runtime.
# Solve the rivz2 xcb error.
# See https://github.com/timongentzsch/Jetson_Ubuntu20_Images/blob/master/scripts/jetson_docker_scripts
ARG L4T_RELEASE_MAJOR=32.7
ARG L4T_RELEASE_MINOR=1
ARG CUDA=10.2
ARG DEBIAN_FRONTEND=noninteractive
ARG SOC="t210"

ARG L4T_RELEASE=$L4T_RELEASE_MAJOR.$L4T_RELEASE_MINOR

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils software-properties-common && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

#
# Jetson debian packages
#
RUN echo $L4T_RELEASE_MAJOR
ADD --chown=root:root https://repo.download.nvidia.com/jetson/jetson-ota-public.asc /etc/apt/trusted.gpg.d/jetson-ota-public.asc
RUN chmod 644 /etc/apt/trusted.gpg.d/jetson-ota-public.asc && \
    apt-get update && apt-get install -y --no-install-recommends ca-certificates && \
    echo "deb https://repo.download.nvidia.com/jetson/common r$L4T_RELEASE_MAJOR main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
    echo "deb https://repo.download.nvidia.com/jetson/${SOC} r$L4T_RELEASE_MAJOR main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

#
# Tegra setup
#
RUN apt-get update && \
    apt-get install -y libglu1-mesa-dev freeglut3 freeglut3-dev unzip dialog && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN echo "/usr/lib/aarch64-linux-gnu/tegra" >> /etc/ld.so.conf.d/nvidia-tegra.conf && \
    echo "/usr/lib/aarch64-linux-gnu/tegra-egl" >> /etc/ld.so.conf.d/nvidia-tegra.conf
RUN rm /usr/share/glvnd/egl_vendor.d/50_mesa.json
RUN mkdir -p /usr/share/glvnd/egl_vendor.d/ && \
    echo '{"file_format_version" : "1.0.0" , "ICD" : { "library_path" : "libEGL_nvidia.so.0" }}' > /usr/share/glvnd/egl_vendor.d/10_nvidia.json
RUN mkdir -p /usr/share/egl/egl_external_platform.d/ && \
    echo '{"file_format_version" : "1.0.0" , "ICD" : { "library_path" : "libnvidia-egl-wayland.so.1" }}' > /usr/share/egl/egl_external_platform.d/nvidia_wayland.json
RUN echo "/usr/local/cuda-$CUDA/targets/aarch64-linux/lib" >> /etc/ld.so.conf.d/nvidia.conf

RUN ldconfig

#
# Update environment
#
ENV PATH /usr/local/cuda-$CUDA/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda-$CUDA/targets/aarch64-linux/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/opt/nvidia/vpi1/lib64:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra-egl:${LD_LIBRARY_PATH}

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV OPENBLAS_CORETYPE=ARMV8

ENV QT_X11_NO_MITSHM=1


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