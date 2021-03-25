# ------------------------------------------------------------------------------
# Build Stage
# ------------------------------------------------------------------------------

FROM golang:alpine as build

WORKDIR /usr/local/src

RUN set -x \
    # install build dependencies
    && apk add --update --no-cache --no-progress git \
    \
    # download and build supervisord
    && go get -v -u github.com/ochinchina/supervisord \
    && CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-extldflags -static" -o /usr/local/bin/supervisord github.com/ochinchina/supervisord \
    \
    # download and build supercronic
    && go get -v -u github.com/aptible/supercronic \
    && CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-extldflags -static" -o /usr/local/bin/supercronic github.com/aptible/supercronic \
    \
    # clean up
    && rm -rf /var/cache/apk/* /go/src



# ------------------------------------------------------------------------------
# Final Stage
# ------------------------------------------------------------------------------

FROM ubuntu:20.04

ARG LANG=en_US.UTF-8
ARG APT_CACHER_NG
ARG UBUNTU_MIRROR=http://archive.ubuntu.com/ubuntu/
ENV TERM=xterm \
    DEBIAN_FRONTEND=noninteractive \
    LANG=$LANG \
    LC_ALL=$LANG \
    TZ=:/etc/localtime \
    TINI_VERSION=v0.18.0 \
    TINI_PGP_KEY_ID=595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7

RUN set -x \
    \
    # add container user (cu)
    && useradd -r -u 999 -m --shell /bin/bash -G root cu \
    && chmod g+rwX,o-rwx /home/cu \
    \
    # configure apt
    && sed -ri "s%http://(archive|security)\.ubuntu\.com/ubuntu/%$UBUNTU_MIRROR%g" /etc/apt/sources.list \
    && { \
        echo "APT::Install-Recommends 0;"; \
        echo "APT::Install-Suggests 0;"; \
    } >> /etc/apt/apt.conf.d/01norecommends \
    && if [ -n "$APT_CACHER_NG" ]; then echo "Acquire::http { Proxy \"$APT_CACHER_NG\"; };" >> /etc/apt/apt.conf.d/01proxy; fi \
    && apt-get update \
    \
    # fix some problems with package install
    && dpkg-divert --local --rename --add /sbin/initctl \
    && ln -sf /bin/true /sbin/initctl \
    && dpkg-divert --local --rename --add /usr/bin/ischroot \
    && ln -sf /bin/true /usr/bin/ischroot \
    && unset http_proxy https_proxy \
    \
    # generate locales
    && apt-get install -y locales \
    && sed -i -e "s/# $LANG/$LANG/" /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale language=$LANG \
    \
    # install software
    && apt-get install -y \
        ca-certificates \
        curl \
        dirmngr \
        gnupg \
        nano \
        python3-minimal \
        python3-pip \
        python3-setuptools \
        python3-wheel \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    && curl -fSL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" -o /sbin/tini \
    && curl -fSL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc" -o /tmp/tini.asc \
    && ( gpg --keyserver ipv4.pool.sks-keyservers.net --keyserver-options timeout=10 --recv-keys "$TINI_PGP_KEY_ID" \
        || gpg --keyserver pgp.mit.edu --keyserver-options timeout=10 --recv-keys "$TINI_PGP_KEY_ID" \
        || gpg --keyserver keyserver.pgp.com --keyserver-options timeout=10 --recv-keys "$TINI_PGP_KEY_ID" ) \
    && gpg --verify /tmp/tini.asc /sbin/tini \
    && chmod 755 /sbin/tini \
    && pip3 install schedule \
    && pip3 install Templer \
    \
    # cleanup
    && find /usr/lib/python* -name __pycache__ -exec rm -r {} + \
    && rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/tini.asc

COPY --from=build /usr/local/bin/* /usr/local/bin/
COPY provision /provision
COPY static /
RUN chmod 0755 /entrypoint /usr/bin/workdirs /usr/bin/schedule_program \
    && find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} + \
    \
    # prepare working directories
    && workdirs \
        /container/log \
        /etc/supervisor \
        /usr/local/src \
        /var/run/container

ENTRYPOINT ["/entrypoint"]
CMD ["run"]

LABEL org.opencontainers.image.title="Base Image - Ubuntu" \
    org.opencontainers.image.version="20.04" \
    org.opencontainers.image.description="A base image build upon Ubuntu" \
    org.opencontainers.image.url="https://www.ubuntu.com" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/base"
