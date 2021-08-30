# aisberg/roundcube aisberg/roundcube:1.2.2
ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx-php7
MAINTAINER Andre Lehmann <aisberg@posteo.de>

ENV ROUNDCUBE_VERSION=1.2.2 \
    SHA256_CHECKSUM=b919e797b8bf5ed34748d067dc281f45f29ad71dbad8904bdc0e2258912666ef

RUN wget -q https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz -O /usr/local/src/roundcube.tar.gz &&\
    echo "$SHA256_CHECKSUM /usr/local/src/roundcube.tar.gz" | sha256sum -c &&\
    apt-get update &&\
    apt-get install -y \
        php-pear \
        patch \
        gpgv2 &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

ENV CONTAINER_TYPE=roundcube \
    IMAGE_NAME=aisberg/roundcube \
    IMAGE_MAINTAINER="Andre Lehmann <aisberg@posteo.de>" \
    IMAGE_VERSION=2.0 \
    IMAGE_DESCRIPTION="Roundcube is an open-source web frontend for reading and sending E-Mails. (https://roundcube.net/)" \
    PERSISTENT_DIRS="/var/www/roundcube"

VOLUME ["/var/www/roundcube"]
