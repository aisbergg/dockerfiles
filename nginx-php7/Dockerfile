ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp \
    LD_PRELOAD="/usr/lib/preloadable_libiconv.so php"

RUN set -x \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        composer \
        gnu-libiconv \
        pcre \
        php7 \
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
        php7-mysqli \
        php7-mysqlnd \
        php7-opcache \
        php7-openssl \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-pecl-apcu \
        php7-pecl-mcrypt \
        php7-pecl-memcached \
        php7-pecl-yaml \
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
    # cleanup
    && rm /etc/php7/php-fpm.d/* \
    \
    # prepare working directories
    && workdirs \
        /etc/php7 \
        /var/cache/php/tmp

COPY provision /provision

LABEL org.opencontainers.image.title="Nginx-PHP7" \
    org.opencontainers.image.description="PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation." \
    org.opencontainers.image.url="https://php-fpm.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/aisbergg/dockerfiles/nginx-php7"
