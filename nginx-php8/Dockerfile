ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx

ENV COMPOSER_VERSION=2.1.9 \
    COMPOSER_SHA256_CHECKSUM=4d00b70e146c17d663ad2f9a21ebb4c9d52b021b1ac15f648b4d371c04d648ba \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp \
    LD_PRELOAD="/usr/lib/preloadable_libiconv.so php"

RUN set -x \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        gnu-libiconv \
        pcre \
        php8 \
        php8-bcmath \
        php8-cgi \
        php8-ctype \
        php8-curl \
        php8-dom \
        php8-fpm \
        php8-iconv \
        php8-intl \
        php8-json \
        php8-mbstring \
        php8-mysqli \
        php8-mysqlnd \
        php8-opcache \
        php8-openssl \
        php8-pdo_mysql \
        php8-pdo_pgsql \
        php8-pdo_sqlite \
        php8-pecl-apcu \
        php8-pecl-mcrypt \
        php8-pecl-memcached \
        php8-pecl-yaml \
        php8-pgsql \
        php8-phar \
        php8-posix \
        php8-session \
        php8-simplexml \
        php8-soap \
        php8-sockets \
        php8-sqlite3 \
        php8-xml \
        php8-xmlreader \
        php8-xmlwriter \
        php8-zip \
        php8-zlib \
        yaml \
        zlib \
    \
    # install PHP Composer (packaged version has php7 deps)
    && curl -fSL "https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar" -o /usr/bin/composer \
    && echo "$COMPOSER_SHA256_CHECKSUM  /usr/bin/composer" | sha256sum -c \
    && chmod +x /usr/bin/composer \
    \
    # cleanup
    && rm /etc/php8/php-fpm.d/* \
    \
    # prepare working directories
    && workdirs \
        /etc/php8 \
        /var/cache/php/tmp

COPY provision /provision

LABEL org.opencontainers.image.title="Nginx-PHP8" \
    org.opencontainers.image.description="PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation." \
    org.opencontainers.image.url="https://php-fpm.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/aisbergg/dockerfiles/nginx-php8"
