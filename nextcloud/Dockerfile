# aisberg/nextcloud aisberg/nextcloud:12.0.4
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.6 \
    Comment="Nextcloud is an open-source client-server software for creating file hosting services. (https://nextcloud.org/)"

ENV NEXTCLOUD_VERSION=12.0.4 \
    PGP_KEY_ID=28806A878AE423A28372792ED75899B9A724937A

RUN wget -q "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" -O /usr/local/src/nextcloud.tar.bz2 &&\
    wget -q "https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc" -O /usr/local/src/nextcloud.tar.bz2.asc &&\
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $PGP_KEY_ID &&\
    gpg --verify /usr/local/src/nextcloud.tar.bz2.asc /usr/local/src/nextcloud.tar.bz2 &&\
    apt-get update && apt-get install -y cron php-redis &&\
    `# phply is used for merging the php configuration files` &&\
    pip2 install phply &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/nextcloud \
    /var/lib/nextcloud \
    /etc/www/nginx/conf.d/nextcloud
