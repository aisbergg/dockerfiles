# aisberg/phplist aisberg/phplist:3.3.1
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.4 \
    Comment="phpList is an open-source newsletter and email marketing software. (https://www.phplist.org/)"

ENV PHPLIST_VERSION=3.3.1 \
    SHA256_CHECKSUM=d22b43eab6ead43a44167dce6eb54cb08501534ec27bd6400257314b9c8474fa \
    CKEDITOR_VERSION=4.7.3 \
    CKEDITOR_SHA256_CHECKSUM=b165600c16e97d6f31faf59642a243a5c72427b675101805345c125be9931f04

RUN wget -q "https://sourceforge.net/projects/phplist/files/phplist/${PHPLIST_VERSION}/phplist-${PHPLIST_VERSION}.tgz/download" -O /usr/local/src/phplist.tgz &&\
    wget -q "http://download.cksource.com/CKEditor/CKEditor/CKEditor ${CKEDITOR_VERSION}/ckeditor_${CKEDITOR_VERSION}_standard.zip" -O /usr/local/src/ckeditor.zip &&\
    echo "$SHA256_CHECKSUM /usr/local/src/phplist.tgz\n$CKEDITOR_SHA256_CHECKSUM /usr/local/src/ckeditor.zip" | sha256sum -c &&\
    apt-get update &&\
    apt-get install -y cron patch &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/phplist \
    /etc/nginx/conf.d/phplist
