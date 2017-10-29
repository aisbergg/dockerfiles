# aisberg/nginx-php7
FROM aisberg/nginx
MAINTAINER Andre Lehmann <aisberg@posteo.de>

RUN apt-get update &&\
    apt-get install -y \
        php7.0 \
        php7.0-common \
        php7.0-cgi \
        php7.0-cli \
        php7.0-curl \
        php7.0-imap \
        php7.0-intl \
        php7.0-fpm \
        php7.0-gd \
        php7.0-json \
        php7.0-ldap \
        php7.0-mbstring \
        php7.0-mcrypt \
        php7.0-mysql \
        php7.0-pgsql \
        php7.0-readline \
        php7.0-sqlite3 \
        php7.0-xml \
        php7.0-zip \
        php-imagick \
        php-apcu &&\
    rm -rf /var/lib/apt/lists/* /etc/php/7.0/fpm/pool.d/*

COPY provision/ /provision
