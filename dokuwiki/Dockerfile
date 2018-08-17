FROM aisberg/nginx-php7

ENV DOKUWIKI_VERSION=2018-04-22 \
    DOKUWIKI_SHA256_CHECKSUM=508ae5f9d9a3fd3743b48de1b8c4b39ed8c8dc4bc34db68e7c5bdf989f538ef8

RUN set -x \
    \
    # download DokuWiki sources
    && curl -fSL "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" -o /usr/local/src/dokuwiki.tgz \
    && echo "$DOKUWIKI_SHA256_CHECKSUM  /usr/local/src/dokuwiki.tgz" | sha256sum -c \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        php7-apcu \
        php7-curl \
        php7-gd \
        php7-json \
        php7-opcache \
        php7-openssl \
        php7-xml \
        php7-zlib \
    \
    # prepare working directories
    && workdirs /container/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="DokuWiki" \
    org.opencontainers.image.version="$DOKUWIKI_VERSION" \
    org.opencontainers.image.description="DokuWiki is an open-source web application for creating a wiki." \
    org.opencontainers.image.url="https://www.dokuwiki.org/provision" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/dokuwiki" \
    org.opencontainers.image.created="$CREATED"
