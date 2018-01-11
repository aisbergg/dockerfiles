# aisberg/phpbb aisberg/phpbb:3.2.2
FROM aisberg/nginx-php5

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.2 \
    Comment="PhpBB is an open-source forum software. (https://www.phpbb.com/)"

MAINTAINER Andre Lehmann <aisberg@posteo.de>

ENV PHPBB_VERSION=3.2.2 \
    PHPBB_SHA256_CHECKSUM=ea59e6a9404916bf7937003bdea5fd6aa41f9b7463f7dff3b39c277207ba7bfa

RUN wget -q "https://www.phpbb.com/files/release/phpBB-${PHPBB_VERSION}.zip" -O /usr/local/src/phpbb.zip &&\
    echo "$PHPBB_SHA256_CHECKSUM /usr/local/src/phpbb.zip" | sha256sum -c &&\
    apt-get update &&\
    apt-get install -y imagemagick &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/phpbb \
    /etc/nginx/conf.d/phpbb
