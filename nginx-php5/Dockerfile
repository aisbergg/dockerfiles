FROM aisberg/nginx

ENV COMPOSER_VERSION=1.7.2 \
    COMPOSER_SHA256_CHECKSUM=ec3428d049ae8877f7d102c2ee050dbd51a160fc2dde323f3e126a3b3846750e \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp

RUN set -x \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        pcre \
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
        php5-posix \
        php5-soap \
        php5-sockets \
        php5-sqlite3 \
        php5-xml \
        php5-xmlreader \
        php5-zip \
        php5-zlib \
        zlib \
    && ln -sf /usr/bin/php5 /usr/bin/php \
    \
    # install PHP Composer
    && curl -s -o /usr/bin/composer "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" \
    && echo "$COMPOSER_SHA256_CHECKSUM  /usr/bin/composer" | sha256sum -c \
    && chmod +x /usr/bin/composer \
    \
    # prepare working directories
    && workdirs \
        /etc/php5 \
        /etc/php5/php-fpm.d \
        /var/cache/php/tmp

COPY provision /provision

ARG CREATED
LABEL org.opencontainers.image.title="Nginx-PHP5" \
    org.opencontainers.image.version="5.6.37" \
    org.opencontainers.image.description="PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation." \
    org.opencontainers.image.url="https://php-fpm.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/nginx-php5" \
    org.opencontainers.image.created="$CREATED"
