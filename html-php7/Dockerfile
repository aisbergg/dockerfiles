FROM aisberg/nginx-php7

ARG CREATED
LABEL org.opencontainers.image.title="HTML+PHP7" \
    org.opencontainers.image.description="Webserver with PHP capabilities" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/html-php7" \
    org.opencontainers.image.created="$CREATED"

# install imagemagick
RUN apk add --update --no-cache --no-progress \
        graphviz \
        imagemagick \
        imagemagick-libs \
        shared-mime-info

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} + &&\
    workdirs /var/www/html

VOLUME /var/www/html \
    /etc/nginx/conf.d

USER 999
