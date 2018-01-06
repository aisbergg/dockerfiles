# aisberg/gosa aisberg/gosa
FROM aisberg/nginx-php5
MAINTAINER Andre Lehmann <aisberg@posteo.de>

RUN apt-get update &&\
    apt-get install -y \
        gosa \
        gosa-plugin-connectivity \
        gosa-plugin-dns \
        gosa-plugin-ldapmanager \
        gosa-plugin-mailaddress \
        gosa-plugin-mit-krb5 \
        gosa-plugin-mit-krb5-schema \
        gosa-plugin-nagios \
        gosa-plugin-nagios-schema \
        gosa-plugin-rolemanagement \
        gosa-plugin-ssh \
        gosa-plugin-ssh-schema \
        gosa-plugin-sudo \
        gosa-plugin-sudo-schema &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision

ENV CONTAINER_TYPE=gosa \
    IMAGE_NAME=aisberg/gosa \
    IMAGE_MAINTAINER="Andre Lehmann <aisberg@posteo.de>" \
    IMAGE_VERSION=1.0 \
    IMAGE_DESCRIPTION="Framework for managing accounts and systems in LDAP databases. (https://oss.gonicus.de/labs/gosa)" \
    PERSISTENT_DIRS="/var/www/gosa;/etc/nginx/conf.d/gosa"

VOLUME /etc/gosa
