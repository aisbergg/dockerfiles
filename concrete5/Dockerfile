FROM aisberg/nginx-php7

ENV CONCRETE5_VERSION=8.3.2 \
    CONCRETE5_SHA256_CHECKSUM=86e38b59e6c488c2b9621c1fd80f60975c31b5910b49a13da7ccf3739efe232e

# PHP requirements: https://documentation.concrete5.org/developers/installation/system-requirements
RUN curl -fSL "https://www.concrete5.org/download_file/-/view/100595/concrete5-${CONCRETE5_VERSION}.zip" -o /usr/local/src/concrete5.zip &&\
    echo "$CONCRETE5_SHA256_CHECKSUM  /usr/local/src/concrete5.zip" | sha256sum -c &&\
    apk add --update --no-cache --no-progress \
        php7-apcu \
        php7-curl \
        php7-dom \
        php7-fileinfo \
        php7-gd \
        php7-iconv \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqli \
        php7-opcache \
        php7-pdo_mysql \
        php7-simplexml \
        php7-tokenizer \
        php7-xml \
        php7-xmlreader \
        php7-xmlwriter \
        php7-zip &&\
    workdirs /var/www/concrete5

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /var/www/concrete5 \
    /etc/nginx/conf.d

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="Concrete5" \
    org.opencontainers.image.version="$CONCRETE5_VERSION" \
    org.opencontainers.image.description="Concrete5 is an open-source content management system (CMS)." \
    org.opencontainers.image.url="http://www.concrete5.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/concrete5" \
    org.opencontainers.image.created="$CREATED"
