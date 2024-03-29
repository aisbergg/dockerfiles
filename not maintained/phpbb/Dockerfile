ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx-php5

ENV PHPBB_VERSION=3.2.5 \
    PHPBB_SHA256_CHECKSUM=7706292fe4b2f7eb988a7b688c29cbe9c8e86f7f51c759c5aab9fc176e695f44

RUN set -x \
    \
    # download phpBB sources
    && curl -fSL "https://www.phpbb.com/files/release/phpBB-${PHPBB_VERSION}.zip" -o /usr/local/src/phpbb.zip \
    && echo "$PHPBB_SHA256_CHECKSUM  /usr/local/src/phpbb.zip" | sha256sum -c \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        php5-apcu \
        php5-gd \
        php5-json \
        php5-mysqli \
        php5-opcache \
        php5-xml \
        rsync \
    && apk add --update --no-cache --no-progress --repository ${ALPINE_MIRROR}edge/main/ \
        ghostscript-fonts \
        imagemagick \
        imagemagick-libs \
        shared-mime-info \
    \
    # prepare working directories
    && workdirs \
        /container/www \
        /etc/ImageMagick-7

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www

USER 999

LABEL org.opencontainers.image.title="phpBB" \
    org.opencontainers.image.version="$PHPBB_VERSION" \
    org.opencontainers.image.description="PhpBB is an open-source forum software." \
    org.opencontainers.image.url="https://www.phpbb.com/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/phpbb"
