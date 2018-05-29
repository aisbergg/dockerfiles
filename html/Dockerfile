FROM aisberg/nginx

ARG CREATED
LABEL org.opencontainers.image.title="Nginx HTML" \
    org.opencontainers.image.description="Webserver for delivering static HTML" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/html" \
    org.opencontainers.image.created="$CREATED"

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} + &&\
    \
    # prepare working directories
    ln -sf /container/nginx /etc/nginx/conf.d &&\
    workdirs \
        /container/www \
        /container/nginx \
        /etc/ImageMagick-7

VOLUME /container/www \
    /container/nginx

USER 999
