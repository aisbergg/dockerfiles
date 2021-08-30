ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx-php7

RUN set -x \
    \
    # install required packages
    # PHP requirements: https://learn.getgrav.org/basics/requirements#php-requirements
    && apk add --update --no-cache --no-progress \
        git \
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
        # php7-yaml \
        php7-zip \
        # for TNTSearch plugin
        php7-pdo_mysql \
        php7-pdo_sqlite \
        sqlite \
    \
    # prepare working directory
    && workdirs /container/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www

USER 999

LABEL org.opencontainers.image.title="Grav CMS" \
    org.opencontainers.image.description="Modern, Crazy Fast, Ridiculously Easy and Amazingly Powerful Flat-File CMS." \
    org.opencontainers.image.url="https://getgrav.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/grav"
