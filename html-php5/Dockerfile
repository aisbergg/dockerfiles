# aisberg/html-php5
FROM aisberg/nginx-php5

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.1 \
    Comment="Webserver with PHP capabilities"

COPY provision/ /provision

VOLUME /var/www/html-php \
    /etc/nginx/conf.d/html-php
