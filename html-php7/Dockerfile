# aisberg/html-php7
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.1 \
    Comment="Webserver with PHP capabilities"

COPY provision/ /provision

VOLUME /var/www/html-php \
    /etc/nginx/conf.d/html-php
