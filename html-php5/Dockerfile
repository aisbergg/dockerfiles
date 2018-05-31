FROM aisberg/nginx-php5

RUN \
    # install required packages
    apk add --update --no-cache --no-progress \
        php5-gd \
        php5-zlib &&\
    apk add --update --no-cache --no-progress --repository ${ALPINE_MIRROR}edge/main/ \
        ghostscript-fonts \
        imagemagick \
        imagemagick-libs \
        shared-mime-info &&\
    \
    # prepare working directories
    ln -sf /container/nginx /etc/nginx/conf.d &&\
    workdirs \
        /container/www \
        /container/nginx \
        /etc/ImageMagick-7

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www \
    /container/nginx

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="HTML+PHP5" \
    org.opencontainers.image.description="Webserver with PHP capabilities" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/html-php5" \
    org.opencontainers.image.created="$CREATED"
