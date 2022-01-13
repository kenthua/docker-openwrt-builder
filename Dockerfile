FROM alpine:edge

RUN apk add git build-base bash ncurses-dev perl tar findutils patch coreutils gawk grep unzip bzip2 wget python2 python3 curl diffutils bsd-compat-headers less diffutils zlib-dev file sudo rsync && \
    addgroup -S user && \
    adduser -D -G user user && \
    echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user

# set dummy git config
RUN git config --global user.name "user" && git config --global user.email "user@example.com"

RUN git clone -b openwrt-21.02-tweaks https://github.com/kenthua/openwrt

WORKDIR /home/user/openwrt

RUN ./scripts/feeds update -a 
RUN ./scripts/feeds install -a
RUN cp configs/OrangePi_R1_Plus_LTS_defconfig .config
RUN make defconfig
RUN make -j $(nproc)
RUN ls -latR /home/user/openwrt/bin
RUN mkdir /home/user/images && mv /home/user/openwrt/bin/targets/rockchip/armv8/* /home/user/images
RUN ls -latR /home/user/images
RUN make clean

WORKDIR /home/user