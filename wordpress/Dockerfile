# aisberg/wordpress aisberg/wordpress:4.8.2
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.7 \
    Comment="Wordpress is an open-source content management system (CMS). (https://wordpress.org/)"

ENV WORDPRESS_VERSION=4.8.2 \
    SHA256_CHECKSUM=c2c65d156e1f3f1d81bbb61a4bb7267b108a09130d46d33b9b9c6b2e93e16752

RUN wget -q "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" -O /usr/local/src/wordpress.tar.gz &&\
    echo "$SHA256_CHECKSUM /usr/local/src/wordpress.tar.gz" | sha256sum -c &&\
    apt-get update &&\
    apt-get install -y imagemagick &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/wordpress \
    /etc/nginx/conf.d/wordpress
