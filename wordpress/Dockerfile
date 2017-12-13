# aisberg/wordpress aisberg/wordpress:4.9
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.8 \
    Comment="Wordpress is an open-source content management system (CMS). (https://wordpress.org/)"

ENV WORDPRESS_VERSION=4.9 \
    SHA256_CHECKSUM=e20dc8d14a62aea05a6eba0a37cabf0b83282746242dab2bd6b9728fc12c28be

RUN wget -q "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" -O /usr/local/src/wordpress.tar.gz &&\
    echo "$SHA256_CHECKSUM /usr/local/src/wordpress.tar.gz" | sha256sum -c &&\
    apt-get update &&\
    apt-get install -y imagemagick &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/wordpress \
    /etc/nginx/conf.d/wordpress
