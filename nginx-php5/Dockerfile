# aisberg/nginx-php5
FROM aisberg/nginx
MAINTAINER Andre Lehmann <aisberg@posteo.de>

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu zesty main" >> /etc/apt/sources.list &&\
    apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C &&\
    apt-get update &&\
    apt-get install -y \
        php5.6 \
        php5.6-common \
        php5.6-cgi \
        php5.6-cli \
        php5.6-curl \
        php5.6-imap \
        php5.6-intl \
        php5.6-fpm \
        php5.6-gd \
        php5.6-json \
        php5.6-ldap \
        php5.6-mbstring \
        php5.6-mcrypt \
        php5.6-mysql \
        php5.6-pgsql \
        php5.6-readline \
        php5.6-sqlite3 \
        php5.6-xml \
        php5.6-zip \
        php-apcu &&\
    rm -rf /var/lib/apt/lists/* /etc/php/5.6/fpm/pool.d/*

COPY provision/ /provision
