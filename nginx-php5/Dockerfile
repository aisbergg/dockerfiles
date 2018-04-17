FROM aisberg/nginx

ENV COMPOSER_VERSION=1.6.4 \
    COMPOSER_SHA256_CHECKSUM=8d0d9246f68532cc8fd6a47a58d195f0c849d26430f93c397a3176fc2d971ded \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp

RUN apk add --update --no-cache --no-progress \
        pcre \
        zlib \
        php5 \
        php5-apcu \
        php5-bcmath \
        php5-cgi \
        php5-cli \
        php5-ctype \
        php5-curl \
        php5-dom \
        php5-fpm \
        php5-iconv \
        php5-intl \
        php5-json \
        php5-mcrypt \
        php5-mysqli \
        php5-opcache \
        php5-openssl \
        php5-pdo_mysql \
        php5-pdo_pgsql \
        php5-pdo_sqlite \
        php5-pgsql \
        php5-phar \
        php5-soap \
        php5-sockets \
        php5-sqlite3 \
        php5-xml \
        php5-xmlreader \
        php5-zip \
        php5-zlib &&\
    ln -sf /usr/bin/php5 /usr/bin/php &&\
    `#---- install Composer ----#` &&\
    curl -s -o /usr/bin/composer "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" &&\
    echo "$COMPOSER_SHA256_CHECKSUM  /usr/bin/composer" | sha256sum -c &&\
    chmod +x /usr/bin/composer &&\
    `#---- directories and files ----#` &&\
    workdirs \
        /etc/php5 \
        /etc/php5/php-fpm.d \
        /var/cache/php/tmp \
        /var/run/php

COPY provision /provision

ARG CREATED
LABEL org.opencontainers.image.title="Nginx-PHP5" \
    org.opencontainers.image.version="5.6.35" \
    org.opencontainers.image.description="PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation." \
    org.opencontainers.image.url="https://php-fpm.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/nginx-php5" \
    org.opencontainers.image.created="$CREATED"
