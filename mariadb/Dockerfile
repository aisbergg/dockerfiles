FROM aisberg/base-alpine:3.7

ENV INIT=supervisor

RUN \
    # install required packages
    apk add --update --no-cache --no-progress --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
        libressl \
        ca-certificates \
        mariadb \
        mariadb-client \
        mariadb-server-utils \
        tzdata &&\
    \
    # prepare directories and files
    rm -rf /etc/mysql/* &&\
    ln -sf /usr/share/mariadb /usr/share/mysql &&\
    workdirs \
        /container/db \
        /container/tls \
        /etc/mysql

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /container/db

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="MariaDB" \
    org.opencontainers.image.version="10.2" \
    org.opencontainers.image.description="MariaDB is a community-developed fork of the MySQL relational database management system." \
    org.opencontainers.image.url="https://mariadb.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/mariadb" \
    org.opencontainers.image.created="$CREATED"
