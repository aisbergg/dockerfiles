FROM aisberg/nginx

ENV COMPOSER_VERSION=1.6.4 \
    COMPOSER_SHA256_CHECKSUM=8d0d9246f68532cc8fd6a47a58d195f0c849d26430f93c397a3176fc2d971ded \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp

RUN apk add --update --no-cache --no-progress \
        php7 \
        php7-apcu \
        php7-bcmath \
        php7-bz2 \
        php7-cgi \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fpm \
        php7-gd \
        php7-gettext \
        php7-gmp \
        php7-iconv \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqli \
        php7-odbc \
        php7-opcache \
        php7-openssl \
        php7-pdo \
        php7-pdo_dblib \
        php7-pdo_mysql \
        php7-pdo_odbc \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-session \
        php7-soap \
        php7-sqlite3 \
        php7-xmlreader \
        php7-zip \
        php7-zlib &&\
    wget -q "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" -O /usr/bin/composer &&\
    echo "$COMPOSER_SHA256_CHECKSUM  /usr/bin/composer" | sha256sum -c &&\
    chmod +x /usr/bin/composer &&\
    `#---- directories and files ----#` &&\
    rm /etc/php7/php-fpm.d/* &&\
    ln -sf /dev/stdout /var/log/php7/error.log &&\
    workdirs \
        /etc/php7 \
        /var/cache/php/tmp \
        /var/log/php7 \
        /var/run/php

COPY provision /provision

ARG CREATED
LABEL org.opencontainers.image.title="Nginx-PHP7" \
    org.opencontainers.image.version="7.1.15" \
    org.opencontainers.image.description="PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation." \
    org.opencontainers.image.url="https://php-fpm.orgg" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/nginx-php7" \
    org.opencontainers.image.created="$CREATED"
