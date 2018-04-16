FROM aisberg/nginx-php7

# PHP requirements: https://learn.getgrav.org/basics/requirements#php-requirements
RUN apk add --update --no-cache --no-progress \
        php7-apcu \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-gd \
        php7-json \
        php7-mbstring \
        php7-opcache \
        php7-openssl \
        php7-session \
        php7-simplexml \
        php7-tokenizer \
        php7-xml \
        `# php7-yaml` \
        php7-zip &&\
    workdirs /var/www/grav

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /var/www/grav \
    /etc/nginx/conf.d

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="Grav CMS" \
    org.opencontainers.image.description="Modern, Crazy Fast, Ridiculously Easy and Amazingly Powerful Flat-File CMS." \
    org.opencontainers.image.url="https://getgrav.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/grav" \
    org.opencontainers.image.created="$CREATED"
