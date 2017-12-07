# aisberg/grav
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=1.1 \
    Comment="Modern, Crazy Fast, Ridiculously Easy and Amazingly Powerful Flat-File CMS. (https://getgrav.org/)"

RUN apt-get update && apt-get install -y composer php-redis git &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/grav \
    /etc/www/nginx/conf.d/grav
