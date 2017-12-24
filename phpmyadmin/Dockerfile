# aisberg/phpmyadmin aisberg/phpmyadmin:4.7.7
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.12 \
    Comment="PhpMyAdmin is an open-source web frontend for MySQL and MariaDB databases. (https://www.phpmyadmin.net/)"

ENV PHPMYADMIN_VERSION=4.7.7 \
    PGP_KEY_ID=3D06A59ECE730EB71B511C17CE752F178259BD92

RUN wget -q "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz" -O /usr/local/src/phpmyadmin.tar.gz &&\
    wget -q "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz.asc" -O /usr/local/src/phpmyadmin.tar.gz.asc &&\
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$PGP_KEY_ID" &&\
    gpg --verify /usr/local/src/phpmyadmin.tar.gz.asc /usr/local/src/phpmyadmin.tar.gz &&\
    mkdir -p /var/www/phpMyAdmin &&\
    tar xf /usr/local/src/phpmyadmin.tar.gz --strip-components=1 -C /var/www/phpMyAdmin &&\
    chown www-data:www-data -R /var/www/phpMyAdmin &&\
    rm -rf /usr/local/src/phpmyadmin.tar.gz /var/www/phpMyAdmin/{examples,setup}

COPY provision/ /provision

VOLUME /var/lib/mysql_dumps
