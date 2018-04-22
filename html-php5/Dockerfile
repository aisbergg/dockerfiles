FROM aisberg/nginx-php5

RUN apk add --update --no-cache --no-progress \
        graphviz \
        imagemagick \
        imagemagick-libs \
        php5-gd \
        php5-zlib \
        shared-mime-info &&\
    ln -sf /data/html /var/www/html &&\
    ln -sf /data/cfg/nginx/conf.d /etc/nginx/conf.d &&\
    workdirs \
        /data/cfg/nginx/conf.d \
        /data/html \
        /etc/ImageMagick-7

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /data/html \
    /data/cfg

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="HTML+PHP5" \
    org.opencontainers.image.description="Webserver with PHP capabilities" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/html-php5" \
    org.opencontainers.image.created="$CREATED"
