# aisberg/concrete5 aisberg/concrete5:8.2.1
FROM aisberg/nginx-php5

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.3 \
    Comment="Concrete5 is an open-source content management system (CMS). http://www.concrete5.org/)"

ENV CONCRETE5_VERSION=8.2.1 \
    SHA256_CHECKSUM=6413eca00fa235deeea6b44fdf049b6e5204be03fb0cd2359114daa07f06a74b

RUN wget -q "https://www.concrete5.org/download_file/-/view/96959/concrete5-${CONCRETE5_VERSION}.zip" -O /usr/local/src/concrete5.zip &&\
    echo "$SHA256_CHECKSUM /usr/local/src/concrete5.zip" | sha256sum -c

COPY provision/ /provision

VOLUME /var/www/concrete5 \
    /etc/nginx/conf.d/concrete5
