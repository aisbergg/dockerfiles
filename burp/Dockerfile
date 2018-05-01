FROM aisberg/base-alpine

ENV BURP_VERSION=2.2.0 \
    BURP_SHA256_CHECKSUM=3b3a4fe068bd6c5f5823deb36bdf7cc79eb15a28893434edfe1503e89584c4b9

RUN \
    # install required packages
    apk add --update --no-cache --no-progress \
        file \
        libressl \
        librsync \
        libssl1.0 \
        mariadb-client \
        msmtp \
        ncurses \
        uthash \
        yajl \
        zlib &&\
    \
    # download and build Burp
    apk add --no-cache --no-progress --virtual .build-deps \
        autoconf \
        automake \
        check \
        g++ \
        libressl-dev \
        librsync-dev \
        libtool \
        make \
        ncurses-dev \
        pkgconf \
        uthash-dev \
        yajl-dev \
        zlib-dev &&\
    curl -fSL "https://github.com/grke/burp/archive/${BURP_VERSION}.tar.gz" -o /usr/local/src/burp.tar.gz &&\
    echo "$BURP_SHA256_CHECKSUM  /usr/local/src/burp.tar.gz" | sha256sum -c &&\
    tempdir="$(mktemp -d)" &&\
    tar xzf /usr/local/src/burp.tar.gz -C "$tempdir" --strip-components=1 &&\
    ( cd "$tempdir" && autoreconf -vif &&\
    ./configure --prefix=/usr --sysconfdir=/data/burp --localstatedir=/var &&\
    make && make install && make install-configs ) &&\
    rm -rf $tempdir && apk del .build-deps &&\
    \
    # prepare working directories and files
    touch /etc/msmtprc &&\
    chgrp 0 /etc/msmtprc &&\
    chmod g+rw /etc/msmtprc &&\
    workdirs \
        /data/burp \
        /data/backup \
        /data/tls

COPY provision /provision
COPY static /
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} + &&\
    chmod 0755 \
        /usr/bin/mysql-dump \
        /usr/bin/mysql-restore

EXPOSE 4971/tcp 4972/tcp

ARG CREATED
LABEL org.opencontainers.image.title="Burp" \
    org.opencontainers.image.version="$BURP_VERSION" \
    org.opencontainers.image.description="Burp is a backup and restore program" \
    org.opencontainers.image.url="http://burp.grke.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/burp" \
    org.opencontainers.image.created="$CREATED"
