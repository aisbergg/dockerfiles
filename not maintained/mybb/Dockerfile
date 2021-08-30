# aisberg/mybb aisberg/mybb:1814
ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.2 \
    Comment="MyBB is an open-source forum software. (http://www.mybb.com/)"

ENV MYBB_VERSION=1814 \
    MYBB_SHA256_CHECKSUM=db46ad8234ca822ff1168cc5e923c1b26ca611d0d1a5406c25db01b95ffe5b74

RUN wget -q "http://resources.mybb.com/downloads/mybb_${MYBB_VERSION}.zip" -O /usr/local/src/mybb.zip &&\
    echo "$MYBB_SHA256_CHECKSUM /usr/local/src/mybb.zip" | sha256sum -c

COPY provision/ /provision

VOLUME /var/www/mybb \
    /etc/nginx/conf.d/mybb
