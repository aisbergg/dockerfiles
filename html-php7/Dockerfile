ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx-php7

RUN set -x \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        php7-fileinfo \
        php7-gd \
        php7-simplexml \
        php7-tokenizer \
        php7-zlib \
    && apk add --update --no-cache --no-progress --repository ${ALPINE_MIRROR}edge/main/ \
        ghostscript-fonts \
        imagemagick \
        imagemagick-libs \
        shared-mime-info \
    \
    # prepare working directories
    && rm -rf /etc/nginx/conf.d \
    && ln -sf /container/nginx /etc/nginx/conf.d \
    && workdirs \
        /container/www \
        /container/nginx \
        /etc/ImageMagick-7

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www \
    /container/nginx

USER 999

LABEL org.opencontainers.image.title="HTML-PHP7" \
    org.opencontainers.image.description="Webserver with PHP capabilities" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/html-php7"
