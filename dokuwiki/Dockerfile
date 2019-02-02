FROM aisberg/nginx-php7

ENV DOKUWIKI_VERSION=2018-04-22b \
    DOKUWIKI_SHA256_CHECKSUM=071831719a1bd6b9e0ce223b590dc1aec22d199a0fb1204723c237457fdff265

RUN set -x \
    \
    # download DokuWiki sources
    && curl -fSL "https://github.com/splitbrain/dokuwiki/archive/release_stable_${DOKUWIKI_VERSION}.tar.gz" -o /usr/local/src/dokuwiki.tar.gz \
    && echo "$DOKUWIKI_SHA256_CHECKSUM  /usr/local/src/dokuwiki.tar.gz" | sha256sum -c \
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

LABEL org.opencontainers.image.title="DokuWiki" \
    org.opencontainers.image.version="$DOKUWIKI_VERSION" \
    org.opencontainers.image.description="DokuWiki is an open-source web application for creating a wiki." \
    org.opencontainers.image.url="https://www.dokuwiki.org/provision" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/dokuwiki"
