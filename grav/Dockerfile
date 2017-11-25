# aisberg/grav aisberg/grav:1.3.8
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=1.0 \
    Comment="Modern, Crazy Fast, Ridiculously Easy and Amazingly Powerful Flat-File CMS. (https://getgrav.org/)"

ENV GRAV_VERSION=1.3.8 \
    GRAV_SHA256_CHECKSUM=44523bbd302cd0045b5b399db25eddb4731e76d1b5e2a0bcfcb555c18e53c565

RUN wget -q "https://github.com/getgrav/grav/releases/download/${GRAV_VERSION}/grav-admin-v${GRAV_VERSION}.zip" -O /usr/local/src/grav.zip &&\
    echo "$GRAV_SHA256_CHECKSUM /usr/local/src/grav.zip" | sha256sum -c &&\
    apt-get update && apt-get install -y php-redis &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/www/grav \
    /etc/www/nginx/conf.d/grav
