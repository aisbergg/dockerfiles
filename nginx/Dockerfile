FROM aisberg/base-alpine:3.7

ENV INIT=supervisor

RUN \
    # install required packages
    # for informations on Nginx modules see: https://www.nginx.com/resources/wiki/modules/
    apk add --update --no-cache --no-progress --repository ${ALPINE_MIRROR}edge/main/ \
        libressl \
        nginx \
        nginx-mod-http-cache-purge \
        nginx-mod-http-fancyindex \
        nginx-mod-http-headers-more \
        nginx-mod-http-image-filter \
        nginx-mod-http-lua \
        nginx-mod-http-nchan \
        nginx-mod-http-perl \
        nginx-mod-http-redis2 \
        nginx-mod-http-upload-progress \
        nginx-mod-http-upstream-fair \
        nginx-mod-http-xslt-filter \
        nginx-mod-mail \
        nginx-mod-stream &&\
    \
    # prepare directories and files
    rm -rf /var/www/* /etc/nginx/conf.d/* &&\
    workdirs \
        /container/tls \
        /etc/nginx \
        /var/lib/nginx \
        /var/lib/nginx/client_body_temp \
        /var/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

EXPOSE 8080 8443

ARG CREATED
LABEL org.opencontainers.image.title="Nginx" \
    org.opencontainers.image.version="1.12.2" \
    org.opencontainers.image.description="Nginx is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server" \
    org.opencontainers.image.url="http://nginx.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/nginx" \
    org.opencontainers.image.created="$CREATED"
