FROM aisberg/nginx-php5

ENV PHPBB_VERSION=3.2.2 \
    PHPBB_SHA256_CHECKSUM=ea59e6a9404916bf7937003bdea5fd6aa41f9b7463f7dff3b39c277207ba7bfa

RUN \
    # download phpBB sources
    curl -fSL "https://www.phpbb.com/files/release/phpBB-${PHPBB_VERSION}.zip" -o /usr/local/src/phpbb.zip &&\
    echo "$PHPBB_SHA256_CHECKSUM  /usr/local/src/phpbb.zip" | sha256sum -c &&\
    \
    # install required packages
    apk add --update --no-cache --no-progress \
        php5-apcu \
        php5-gd \
        php5-json \
        php5-mysqli \
        php5-opcache \
        php5-xml \
        rsync &&\
    apk add --update --no-cache --no-progress --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
        ghostscript-fonts \
        imagemagick \
        imagemagick-libs \
        shared-mime-info &&\
    \
    # prepare working directories
    workdirs \
        /data/www \
        /etc/ImageMagick-7

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /data/www

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="phpBB" \
    org.opencontainers.image.version="$PHPBB_VERSION" \
    org.opencontainers.image.description="PhpBB is an open-source forum software." \
    org.opencontainers.image.url="https://www.phpbb.com/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/phpbb" \
    org.opencontainers.image.created="$CREATED"
