FROM buildpack-deps:19.10 as build

ENV BURP_VERSION=2.3.20 \
    BURP_SHA256_CHECKSUM=5a205fbacc4f9c815bc6cfcbc8e5f891b144795c23110b06e2ac6c16776d94d8

RUN set -x \
    \
    # install required packages
    && apt-get update \
    && apt-get install -y \
        autoconf \
        automake \
        check \
        g++ \
        libncurses-dev \
        librsync-dev \
        libssl-dev \
        libtool \
        libyajl-dev \
        make \
        pkgconf \
        uthash-dev \
        zlib1g-dev \
    \
    # download and build Burp
    && curl -fSL "https://github.com/grke/burp/archive/${BURP_VERSION}.tar.gz" -o /usr/local/src/burp.tar.gz \
    && echo "$BURP_SHA256_CHECKSUM  /usr/local/src/burp.tar.gz" | sha256sum -c \
    && tempdir="$(mktemp -d)" \
    && tar xzf /usr/local/src/burp.tar.gz -C "$tempdir" --strip-components=1 \
    && cd "$tempdir" \
    && autoreconf -vif \
    && ./configure --prefix=/usr --sysconfdir=/container/burp --localstatedir=/var \
    && make && DESTDIR=/burp make install && DESTDIR=/burp make install-configs \
    && rm -rf $tempdir

#-------------------------------------------------------------------------------

FROM aisberg/base-ubuntu:19.10

COPY --from=build /burp /

RUN set -x \
    \
    # install required packages
    && apt-get update \
    && apt-get install -y \
        file \
        libncurses6 \
        librsync2 \
        libssl1.1 \
        libyajl2 \
        mariadb-client \
        msmtp \
        openssl \
        postgresql-client-11 \
        zlibc \
    && rm -rf /var/lib/apt/lists/* \
    \
    # prepare working directories and files
    && touch /etc/msmtprc \
    && chgrp 0 /etc/msmtprc \
    && chmod g+rw /etc/msmtprc \
    && workdirs \
        /container/burp \
        /container/backup \
        /container/tls

COPY provision /provision
COPY static /
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} + \
    && chmod 0755 \
        /usr/bin/mysql-dump \
        /usr/bin/mysql-restore

EXPOSE 4971/tcp 4972/tcp

LABEL org.opencontainers.image.title="Burp" \
    org.opencontainers.image.version="$BURP_VERSION" \
    org.opencontainers.image.description="Burp is a backup and restore program" \
    org.opencontainers.image.url="http://burp.grke.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/burp"
