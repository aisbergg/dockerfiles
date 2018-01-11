# aisberg/wordpress aisberg/wordpress:4.9.1
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.9 \
    Comment="Wordpress is an open-source content management system (CMS). (https://wordpress.org/)"

ENV WORDPRESS_VERSION=4.9.1 \
    WORDPRESS_SHA256_CHECKSUM=a94ae99cda7666bfd482b36f268ad240a3bde2a66724e1312dabf068a9555100

RUN wget -q "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" -O /usr/local/src/wordpress.tar.gz &&\
    echo "$WORDPRESS_SHA256_CHECKSUM /usr/local/src/wordpress.tar.gz" | sha256sum -c &&\
    apt-get update &&\
    apt-get install -y imagemagick &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/wordpress \
    /etc/nginx/conf.d/wordpress
