# aisberg/mybb aisberg/mybb:1812
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.1 \
    Comment="MyBB is an open-source forum software. (http://www.mybb.com/)"

ENV MYBB_VERSION=1812 \
    SHA256_CHECKSUM=e63bd3ce5b8a7c4166102baa75f0aab1d12fc64379658a027d8bf49a437a469a

RUN wget -q "http://resources.mybb.com/downloads/mybb_${MYBB_VERSION}.zip" -O /usr/local/src/mybb.zip &&\
    echo "$SHA256_CHECKSUM /usr/local/src/mybb.zip" | sha256sum -c

COPY provision/ /provision

VOLUME /var/www/mybb \
    /etc/nginx/conf.d/mybb
