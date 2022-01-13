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
RUN git config --global user.name "user" && git config --global user.email "user@example.com"

RUN git clone -b openwrt-21.02-tweaks https://github.com/kenthua/openwrt
WORKDIR /home/user/openwrt
#RUN ./scripts/feeds update -a 
#RUN ./scripts/feeds install -a
RUN cp configs/OrangePi_R1_Plus_LTS_defconfig .config
#RUN make defconfig
#RUN make -j $(nproc)
#RUN mkdir ${HOME}/images && cp ${HOME}/openwrt/bin/targets/rockchip/armv8/* ${HOME}/images
#RUN make clean

WORKDIR /home/user
