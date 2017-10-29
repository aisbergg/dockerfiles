# aisberg/phpbb aisberg/phpbb:3.2.1
FROM aisberg/nginx-php5

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.2 \
    Comment="PhpBB is an open-source forum software. (https://www.phpbb.com/)"

MAINTAINER Andre Lehmann <aisberg@posteo.de>

ENV PHPBB_VERSION=3.2.1 \
    SHA256_CHECKSUM=30977547dcc59b26a727fecf397f7a6f102816cca0d82028d1d72c1cd881e117

RUN wget -q "https://www.phpbb.com/files/release/phpBB-${PHPBB_VERSION}.zip" -O /usr/local/src/phpbb.zip &&\
    echo "$SHA256_CHECKSUM /usr/local/src/phpbb.zip" | sha256sum -c &&\
    apt-get update &&\
    apt-get install -y imagemagick &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/phpbb \
    /etc/nginx/conf.d/phpbb
