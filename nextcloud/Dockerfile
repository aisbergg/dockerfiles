ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx-php7

ENV NEXTCLOUD_VERSION=19.0.1 \
    NEXTCLOUD_PGP_KEY_ID=28806A878AE423A28372792ED75899B9A724937A

RUN set -x \
    \
    # download Nextcloud sources
    && curl -fSL "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" -o /usr/local/src/nextcloud.tar.bz2 \
    && curl -fSL "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc" -o /usr/local/src/nextcloud.tar.bz2.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && ( gpg --batch --keyserver ha.pool.sks-keyservers.net --keyserver-options timeout=10 --recv-keys "$NEXTCLOUD_PGP_KEY_ID" \
        || gpg --batch --keyserver pgp.mit.edu --keyserver-options timeout=10 --recv-keys "$NEXTCLOUD_PGP_KEY_ID" \
        || gpg --batch --keyserver keyserver.pgp.com --keyserver-options timeout=10 --recv-keys "$NEXTCLOUD_PGP_KEY_ID" ) \
    && gpg --batch --verify /usr/local/src/nextcloud.tar.bz2.asc /usr/local/src/nextcloud.tar.bz2 \
    && gpgconf --kill all && rm -rf "$GNUPGHOME" \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        bzip2 \
        imagemagick \
        imagemagick-libs \
        php7-apcu \
        php7-exif \
        php7-fileinfo \
        php7-gd \
        php7-gmp \
        php7-imagick \
        php7-intl \
        php7-ldap \
        php7-mbstring \
        php7-mcrypt \
        php7-memcached \
        php7-mysqli \
        php7-opcache \
        php7-pcntl \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pgsql \
        php7-posix \
        php7-redis \
        php7-zip \
        rsync \
    \
    # prepare working directories
    && workdirs \
        /etc/ImageMagick-7 \
        /container/www \
        /tmp/nextcloudtemp \
        /var/cache/nginx

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www

USER 999

LABEL org.opencontainers.image.title="Nextcloud" \
    org.opencontainers.image.version="$NEXTCLOUD_VERSION" \
    org.opencontainers.image.description="Nextcloud is an open source, self-hosted file share and communication platform." \
    org.opencontainers.image.url="https://nextcloud.com" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/nextcloud"
