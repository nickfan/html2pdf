# syntax = docker/dockerfile:experimental
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=etc/UTC
ARG TERM="xterm-256color"
ARG WKHTMLTOPDF_VERSION="0.12.6-1"
ARG OS_RELEASE_VERSION="18.04"
ARG OS_RELEASE_NAME="bionic"
ARG OS_ARCH_NAME="amd64"

FROM ubuntu:${OS_RELEASE_VERSION}
LABEL maintainer="Nick Fan <nickfan81@gmail.com>"
ARG DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
ARG TZ
ENV TZ=${TZ}
ARG TERM
ENV TERM=${TERM}
ARG WKHTMLTOPDF_VERSION
ENV WKHTMLTOPDF_VERSION=${WKHTMLTOPDF_VERSION}
ARG OS_RELEASE_VERSION
ENV OS_RELEASE_VERSION=${OS_RELEASE_VERSION}
ARG OS_RELEASE_NAME
ENV OS_RELEASE_NAME=${OS_RELEASE_NAME}
ARG OS_ARCH_NAME
ENV OS_ARCH_NAME=${OS_ARCH_NAME}

SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    sudo net-tools iputils-ping iproute2 telnet curl wget apt-transport-https ca-certificates software-properties-common \
    build-essential gcc g++ make cmake autoconf automake patch gdb libtool cpp pkg-config libc6-dev libncurses-dev sqlite sqlite3 openssl unixodbc gawk bison \
    libpng-dev libjpeg-dev libfreetype6-dev xfonts-75dpi x11-common libxrender-dev libxext-dev xfonts-base xfonts-encodings xfonts-utils fonts-dejavu-core fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy

RUN mkdir -p /data && curl -L -o /root/wkhtmltox_${WKHTMLTOPDF_VERSION}.${OS_RELEASE_NAME}_${OS_ARCH_NAME}.deb https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}/wkhtmltox_${WKHTMLTOPDF_VERSION}.${OS_RELEASE_NAME}_${OS_ARCH_NAME}.deb && \
    dpkg -i /root/wkhtmltox_${WKHTMLTOPDF_VERSION}.${OS_RELEASE_NAME}_${OS_ARCH_NAME}.deb && \
    rm -rf /root/wkhtmltox_${WKHTMLTOPDF_VERSION}.${OS_RELEASE_NAME}_${OS_ARCH_NAME}.deb && rm -rf /var/lib/apt/lists/*

RUN printf "%b" '#!'"/usr/bin/env sh\n \
    if [ \"\$1\" = \"daemon\" ];  then \n \
    tail -f /dev/null \n \
    else \n \
    exec /usr/local/bin/wkhtmltopdf \$@ \n \
    fi" >/entry.sh && chmod +x /entry.sh
ENTRYPOINT ["/entry.sh"]
# ENTRYPOINT ["/usr/local/bin/wkhtmltopdf"]
VOLUME ["/data"]
