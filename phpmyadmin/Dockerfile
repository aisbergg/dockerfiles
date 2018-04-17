FROM aisberg/nginx-php7

ENV PHPMYADMIN_VERSION=4.8.0 \
    PHPMYADMIN_PGP_KEY_ID=3D06A59ECE730EB71B511C17CE752F178259BD92

RUN curl -fSL "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz" -o /usr/local/src/phpmyadmin.tar.gz &&\
    curl -fSL "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz.asc" -o /usr/local/src/phpmyadmin.tar.gz.asc &&\
    ( gpg --keyserver ipv4.pool.sks-keyservers.net --keyserver-options timeout=10 --recv-keys "$PHPMYADMIN_PGP_KEY_ID" \
        || gpg --keyserver pgp.mit.edu --keyserver-options timeout=10 --recv-keys "$PHPMYADMIN_PGP_KEY_ID" \
        || gpg --keyserver keyserver.pgp.com --keyserver-options timeout=10 --recv-keys "$PHPMYADMIN_PGP_KEY_ID" ) &&\
    gpg --verify /usr/local/src/phpmyadmin.tar.gz.asc /usr/local/src/phpmyadmin.tar.gz &&\
    mkdir -p \
        /var/lib/mysql_dumps \
        /var/www/phpMyAdmin &&\
    tar xf /usr/local/src/phpmyadmin.tar.gz --strip-components=1 -C /var/www/phpMyAdmin &&\
    rm -rf \
        /usr/local/src/phpmyadmin.tar.gz \
        /var/www/phpMyAdmin/examples \
        /var/www/phpMyAdmin/setup &&\
    apk add --update --no-cache --no-progress \
        php7-gd \
        php7-json \
        php7-mbstring \
        php7-mysqli \
        php7-openssl \
        php7-session \
        php7-zip &&\
    workdirs \
        /var/lib/mysql_dumps \
        /var/www/phpMyAdmin

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /var/lib/mysql_dumps

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="phpMyAdmin" \
    org.opencontainers.image.version="4.8.0" \
    org.opencontainers.image.description="phpMyAdmin is an open-source web frontend for MySQL and MariaDB databases." \
    org.opencontainers.image.url="https://www.phpmyadmin.net/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/phpmyadmin" \
    org.opencontainers.image.created="$CREATED"
