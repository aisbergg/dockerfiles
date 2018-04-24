FROM aisberg/nginx-php5

RUN \
    # install packages
    apk add --update --no-cache --no-progress \
        graphviz \
        imagemagick \
        imagemagick-libs \
        php5-gd \
        php5-zlib \
        shared-mime-info &&\
    \
    # prepare working directories
    ln -sf /data/nginx /etc/nginx/conf.d &&\
    workdirs \
        /data/www \
        /data/nginx \
        /etc/ImageMagick-7

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /data/www \
    /data/nginx

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="HTML+PHP5" \
    org.opencontainers.image.description="Webserver with PHP capabilities" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/html-php5" \
    org.opencontainers.image.created="$CREATED"
