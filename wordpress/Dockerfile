FROM aisberg/nginx-php7

ENV WORDPRESS_VERSION=5.0.3 \
    WORDPRESS_SHA256_CHECKSUM=9aa4d1bc9acc39279f15e914415be87af01a886287b1b92b3a80426a4edbd78a

RUN set -x \
    \
    # download Wordpress sources
    && curl -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" -o /usr/local/src/wordpress.tar.gz \
    && echo "$WORDPRESS_SHA256_CHECKSUM  /usr/local/src/wordpress.tar.gz" | sha256sum -c \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        php7-apcu \
        php7-gd \
        php7-mysqli \
        php7-opcache \
        php7-tokenizer \
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

LABEL org.opencontainers.image.title="Wordpress" \
    org.opencontainers.image.version="$WORDPRESS_VERSION" \
    org.opencontainers.image.description="Wordpress is an open-source content management system (CMS)." \
    org.opencontainers.image.url="https://wordpress.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/wordpress"
