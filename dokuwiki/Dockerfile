FROM aisberg/nginx-php7

ENV DOKUWIKI_VERSION=2017-02-19e \
    SHA256_CHECKSUM=93172a28ab88107a8abac1e6a34fa6cef54b6e407cd03a8cc14d2a604a63e888

RUN curl -fSL "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" -o /usr/local/src/dokuwiki.tgz && \
    echo "$SHA256_CHECKSUM  /usr/local/src/dokuwiki.tgz" | sha256sum -c &&\
    apk add --update --no-cache --no-progress \
        php7-apcu \
        php7-curl \
        php7-gd \
        php7-json \
        php7-opcache \
        php7-openssl \
        php7-xml \
        php7-zlib &&\
    workdirs /var/www/dokuwiki

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /var/www/dokuwiki \
    /etc/nginx/conf.d

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="Concrete5" \
    org.opencontainers.image.version="$DOKUWIKI_VERSION" \
    org.opencontainers.image.description="DokuWiki is an open-source web application for creating a wiki." \
    org.opencontainers.image.url="https://www.dokuwiki.org/provision" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/dokuwiki" \
    org.opencontainers.image.created="$CREATED"
