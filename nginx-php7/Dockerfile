FROM aisberg/nginx

ENV COMPOSER_VERSION=1.7.1 \
    COMPOSER_SHA256_CHECKSUM=1c0e95dc3f33985f9eeabb6f57896c0f9d46b7c9e70ad7bf2210a5508869a8fa \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp

# inspired by https://github.com/graze/docker-php-alpine
RUN set -xe \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        pcre \
        php7 \
        php7-apcu \
        php7-bcmath \
        php7-cgi \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fpm \
        php7-iconv \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-memcached \
        php7-mysqli \
        php7-mysqlnd \
        php7-opcache \
        php7-openssl \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-pgsql \
        php7-phar \
        php7-posix \
        php7-session \
        php7-simplexml \
        php7-soap \
        php7-sockets \
        php7-sqlite3 \
        php7-xml \
        php7-xmlreader \
        php7-xmlwriter \
        php7-zip \
        php7-zlib \
        yaml \
        zlib \
    \
    # build PHP YAML extension
    && apk add --no-cache --no-progress --virtual .pecl-deps \
        autoconf \
        file \
        gcc \
        libc-dev \
        make \
        pcre-dev \
        php7-dev \
        php7-pear \
        pkgconf \
        re2c \
        yaml-dev \
    && sed -i 's/^exec $PHP -C -n/exec $PHP -C/g' $(which pecl) \
    && pecl channel-update pecl.php.net \
    && pecl install yaml \
    && echo "extension=yaml.so" > /etc/php7/conf.d/01_yaml.ini \
    && rm -rf /usr/share/php7 \
    && apk del .pecl-deps \
    \
    # install PHP Composer
    && curl -fSL "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" -o /usr/bin/composer \
    && echo "$COMPOSER_SHA256_CHECKSUM  /usr/bin/composer" | sha256sum -c \
    && chmod +x /usr/bin/composer \
    \
    # cleanup
    && rm /etc/php7/php-fpm.d/* /var/cache/apk/* \
    \
    # prepare working directories
    && workdirs \
        /etc/php7 \
        /var/cache/php/tmp

COPY provision /provision

ARG CREATED
LABEL org.opencontainers.image.title="Nginx-PHP7" \
    org.opencontainers.image.version="7.2.8" \
    org.opencontainers.image.description="PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation." \
    org.opencontainers.image.url="https://php-fpm.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/nginx-php7" \
    org.opencontainers.image.created="$CREATED"
