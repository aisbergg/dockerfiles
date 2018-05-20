FROM aisberg/nginx

ENV COMPOSER_VERSION=1.6.4 \
    COMPOSER_SHA256_CHECKSUM=8d0d9246f68532cc8fd6a47a58d195f0c849d26430f93c397a3176fc2d971ded \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp

# inspired by https://github.com/graze/docker-php-alpine
RUN \
    # install required packages
    apk add --update --no-cache --no-progress \
        yaml \
        pcre \
        zlib \
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
        php7-zlib &&\
    \
    # build PHP YAML extension
    apk add --no-cache --no-progress --virtual .pecl-deps \
        autoconf \
        file \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        php7-dev \
        php7-pear \
        yaml-dev \
        pcre-dev &&\
    sed -i 's/^exec $PHP -C -n/exec $PHP -C/g' $(which pecl) &&\
    pecl channel-update pecl.php.net &&\
    pecl install yaml &&\
    echo "extension=yaml.so" > /etc/php7/conf.d/01_yaml.ini &&\
    rm -rf /usr/share/php7 &&\
    apk del .pecl-deps &&\
    \
    # install PHP Composer
    curl -fSL "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" -o /usr/bin/composer &&\
    echo "$COMPOSER_SHA256_CHECKSUM  /usr/bin/composer" | sha256sum -c &&\
    chmod +x /usr/bin/composer &&\
    \
    # prepare working directories
    rm /etc/php7/php-fpm.d/* &&\
    workdirs \
        /etc/php7 \
        /var/cache/php/tmp

COPY provision /provision

ARG CREATED
LABEL org.opencontainers.image.title="Nginx-PHP7" \
    org.opencontainers.image.version="7.1.15" \
    org.opencontainers.image.description="PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation." \
    org.opencontainers.image.url="https://php-fpm.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/nginx-php7" \
    org.opencontainers.image.created="$CREATED"
