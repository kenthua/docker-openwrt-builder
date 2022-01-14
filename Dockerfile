FROM debian:buster

RUN apt-get update &&\
    apt-get install -y \
        sudo time git-core subversion build-essential g++ bash make \
        libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk \
        flex gettext wget unzip xz-utils python python-distutils-extra \
        python3 python3-distutils-extra rsync curl libsnmp-dev liblzma-dev \
        libpam0g-dev cpio rsync && \
    apt-get clean && \
    useradd -m user && \
    echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user

# set dummy git config
RUN git config --global user.name "user" \
    && git config --global user.email "user@example.com"

RUN git clone -b openwrt-21.02-tweaks https://github.com/kenthua/openwrt &&\
    cd openwrt &&\
    ./scripts/feeds update -a &&\
    ./scripts/feeds install -a &&\
    cp configs/OrangePi_R1_Plus_LTS_defconfig .config &&\
    make defconfig &&\
    make -j $(nproc) &&\
    mkdir ${HOME}/images &&\
    mv ${HOME}/openwrt/bin/targets/rockchip/armv8/openwrt-rockchip-armv8-* ${HOME}/images &&\
    rm -rf ${HOME}/openwrt