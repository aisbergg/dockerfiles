FROM aisberg/nginx-php7

ENV PHPLIST_VERSION=3.3.9 \
    PHPLIST_SHA256_CHECKSUM=ff8eb6af73852ab93cb0ab39c082469cf2930aa231668dd2dbf550581d0e281b \
    CKEDITOR_VERSION=4.11.2 \
    CKEDITOR_SHA256_CHECKSUM=b158b9eacbf3070e3720af31da0aabcafeb2c1d4f6b3cd197783602fa2b61208

COPY install /install

RUN set -x \
    \
    # install required packages
    # PHP requirements: https://resources.phplist.com/system/start
    && apk add --update --no-cache --no-progress \
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
        php7-xml \
    && pip3 install schedule \
    \
    # download and install phpList
    && bash /install/install-phplist.sh \
    && rm -rf /install \
    \
    # prepare working directories
    && workdirs /container/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www/uploadimages

USER 999

LABEL org.opencontainers.image.title="phpList" \
    org.opencontainers.image.version="$PHPLIST_VERSION" \
    org.opencontainers.image.description="phpList is an open-source newsletter and email marketing software." \
    org.opencontainers.image.url="https://www.phplist.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/phplist"
