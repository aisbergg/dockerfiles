FROM aisberg/nginx-php7

ENV PHPLIST_VERSION=3.3.1 \
    PHPLIST_SHA256_CHECKSUM=d22b43eab6ead43a44167dce6eb54cb08501534ec27bd6400257314b9c8474fa \
    CKEDITOR_VERSION=4.9.2 \
    CKEDITOR_SHA256_CHECKSUM=7830b30ab61c5751c738597c301f757f28f57fc9b11db3449b59dd4c2bb0ee27

COPY install /install

RUN \
    # install required packages
    # PHP requirements: https://resources.phplist.com/system/start
    apk add --update --no-cache --no-progress \
        pcre \
        php7-apcu \
        php7-curl \
        php7-gd \
        php7-gettext \
        php7-iconv \
        php7-imap \
        php7-json \
        php7-mbstring \
        php7-mysqli \
        php7-mysqlnd \
        php7-opcache \
        php7-openssl \
        php7-session \
        php7-simplexml \
        php7-xml &&\
    pip3 install schedule &&\
    \
    # download and install phpList
    bash /install/install-phplist.sh &&\
    rm -rf /install &&\
    \
    # prepare working directories
    workdirs /data/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /data/www/uploadimages

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="phpList" \
    org.opencontainers.image.version="$PHPLIST_VERSION" \
    org.opencontainers.image.description="phpList is an open-source newsletter and email marketing software." \
    org.opencontainers.image.url="https://www.phplist.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/phplist" \
    org.opencontainers.image.created="$CREATED"
