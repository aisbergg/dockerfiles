FROM alpine:3.8

ARG LANG=en_US.UTF-8
ARG ALPINE_MIRROR=http://dl-cdn.alpinelinux.org/alpine/
ENV LANG=$LANG \
    LANGUAGE=$LANG \
    LC_ALL=$LANG \
    ALPINE_MIRROR=$ALPINE_MIRROR \
    TZ=:/etc/localtime \
    \
    HAPROXY_MAJOR=1.8 \
    HAPROXY_VERSION=1.8.13 \
    HAPROXY_SHA256_CHECKSUM=2bf5dafbb5f1530c0e67ab63666565de948591f8e0ee2a1d3c84c45e738220f1

# from https://git.alpinelinux.org/cgit/aports/tree/main/haproxy?h=master
COPY libressl-2.7.patch /usr/src/libressl-2.7.patch
COPY docker-entrypoint.sh /

RUN set -x \
    \
    # install runtime dependencies
    && sed -i "s%http://dl-cdn.alpinelinux.org/alpine/%$ALPINE_MIRROR%g" /etc/apk/repositories \
    && apk update && apk upgrade \
    && apk add --no-progress  \
        ca-certificates \
        libressl \
        tini \
    \
    # build HAProxy against LibreSSL
    # original code from official image: https://hub.docker.com/_/haproxy/
    && apk add --no-progress --virtual .build-deps \
        gcc \
        libc-dev \
        libressl-dev \
        linux-headers \
        lua5.3-dev \
        make \
        pcre2-dev \
        readline-dev \
        tar \
        zlib-dev \
    \
    && wget -O haproxy.tar.gz "https://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" \
    && echo "$HAPROXY_SHA256_CHECKSUM  haproxy.tar.gz" | sha256sum -c \
    && mkdir -p /usr/src/haproxy \
    && tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1 \
    && rm haproxy.tar.gz \
    \
    && ( cd /usr/src/haproxy ; patch -p1 < /usr/src/libressl-2.7.patch ) \
    && makeOpts=' \
        TARGET=linux2628 \
        USE_LUA=1 LUA_INC=/usr/include/lua5.3 LUA_LIB=/usr/lib/lua5.3 \
        USE_OPENSSL=1 \
        USE_PCRE2_JIT=1 USE_STATIC_PCRE2=1 PCREDIR= \
        USE_ZLIB=1 \
    ' \
    && make -C /usr/src/haproxy -j "$(getconf _NPROCESSORS_ONLN)" all $makeOpts \
    && make -C /usr/src/haproxy install-bin $makeOpts \
    \
    && mkdir -p /usr/local/etc/haproxy \
    && cp -R /usr/src/haproxy/examples/errorfiles /usr/local/etc/haproxy/errors \
    && rm -rf /usr/src/haproxy \
    \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --virtual .haproxy-rundeps $runDeps \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

# https://www.haproxy.org/download/1.8/doc/management.txt
# "4. Stopping and restarting HAProxy"
# "when the SIGTERM signal is sent to the haproxy process, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent to the haproxy process"
STOPSIGNAL SIGUSR1

USER 999

EXPOSE 8080 8443 1936
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/container/cfg/haproxy.cfg"]

LABEL org.opencontainers.image.title="HAProxy" \
    org.opencontainers.image.version="$HAPROXY_VERSION" \
    org.opencontainers.image.description="HAProxy is a open-source high availability load balancer and proxy server for TCP and HTTP-based applications" \
    org.opencontainers.image.url="http://www.haproxy.org" \
    org.opencontainers.image.licenses="GPL-2.0" \
    org.opencontainers.image.authors="Docker Community, Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/haproxy"
