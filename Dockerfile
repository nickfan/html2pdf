# syntax = docker/dockerfile:experimental
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=etc/UTC
ARG TERM="xterm-256color"
ARG WKHTMLTOPDF_VERSION="0.12.6-1"

FROM ubuntu:18.04
LABEL maintainer="Nick Fan <nickfan81@gmail.com>"
ARG DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
ARG TZ
ENV TZ=${TZ}
ARG TERM
ENV TERM=${TERM}
ARG WKHTMLTOPDF_VERSION
ENV WKHTMLTOPDF_VERSION=${WKHTMLTOPDF_VERSION}

SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    sudo net-tools iputils-ping iproute2 telnet curl wget apt-transport-https ca-certificates software-properties-common \
    build-essential gcc g++ make cmake autoconf automake patch gdb libtool cpp pkg-config libc6-dev libncurses-dev sqlite sqlite3 openssl unixodbc gawk bison \
    libpng-dev libjpeg-dev libfreetype6-dev xfonts-75dpi x11-common libxrender-dev libxext-dev xfonts-base xfonts-encodings xfonts-utils fonts-dejavu-core fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy

RUN mkdir -p /usr/local/etc && touch /usr/local/etc/ld.so.conf && echo $'# local libs \n\
/usr/local/lib \n\
 ' > /usr/local/etc/ld.so.conf

RUN wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.29.tar.gz ; \
    tar -zxvf glibc-2.29.tar.gz ; \
    mkdir glibc-2.29/build && cd glibc-2.29/build && ../configure --prefix=/usr/local --disable-sanity-checks && make -j18 && sudo make install
RUN mv /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6.origin && \
    ln -s /usr/local/lib/libm.so.6 /lib/x86_64-linux-gnu/ && \
    ln -s /usr/local/lib/libc.so.6 /lib/x86_64-linux-gnu/
RUN curl -L -o /root/wkhtmltox_${WKHTMLTOPDF_VERSION}.focal_amd64.deb https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}/wkhtmltox_${WKHTMLTOPDF_VERSION}.focal_amd64.deb
RUN dpkg -i /root/wkhtmltox_${WKHTMLTOPDF_VERSION}.focal_amd64.deb && \
    rm -rf /root/wkhtmltox_${WKHTMLTOPDF_VERSION}.focal_amd64.deb
RUN mkdir -p /data && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/local/bin/wkhtmltopdf"]
VOLUME ["/data"]
