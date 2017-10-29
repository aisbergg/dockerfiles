# aisberg/html
FROM aisberg/nginx

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.0 \
    Comment="Simple webserver for delivering static HTML."

COPY provision/ /provision

VOLUME /var/www/html \
    /etc/nginx/conf.d/html
