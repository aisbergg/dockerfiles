# aisberg/dokuwiki aisberg/dokuwiki:2017-02-19e
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.2 \
    Comment="DokuWiki is an open-source web application for creating a wiki. (https://www.dokuwiki.org/provision)"

ENV DOKUWIKI_VERSION=2017-02-19e \
    SHA256_CHECKSUM=93172a28ab88107a8abac1e6a34fa6cef54b6e407cd03a8cc14d2a604a63e888

RUN wget -q http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz -O /usr/local/src/dokuwiki.tgz && \
    echo "$SHA256_CHECKSUM /usr/local/src/dokuwiki.tgz" | sha256sum -c

COPY provision/ /provision

VOLUME /var/www/dokuwiki \
    /etc/nginx/conf.d/dokuwiki
