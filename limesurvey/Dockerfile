FROM aisberg/nginx-php7

ENV LIMESURVEY_VERSION=3.15.8 \
    LIMESURVEY_BUILDNUMBER=190130 \
    LIMESURVEY_SHA256_CHECKSUM=0eb46c81c8fce8eb40625a899ed3a32a2f63a4dd9158da7ee2df2d78a67d4c0b

RUN set -x \
    \
    # download Lime Survey sources
    && curl -fSL "https://github.com/LimeSurvey/LimeSurvey/archive/${LIMESURVEY_VERSION}+${LIMESURVEY_BUILDNUMBER}.tar.gz" -o /usr/local/src/limesurvey.tar.gz \
    && echo "$LIMESURVEY_SHA256_CHECKSUM  /usr/local/src/limesurvey.tar.gz" | sha256sum -c \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        php7-apcu \
        php7-gd \
        php7-imap \
        php7-ldap \
        php7-mbstring \
        php7-opcache \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-xml \
        php7-xmlwriter \
        php7-simplexml \
        php7-pdo_pgsql \
        php7-zip \
        php7-zlib \
        rsync \
    \
    # prepare working directories
    && workdirs /container/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www

USER 999

LABEL org.opencontainers.image.title="Lime Survey" \
    org.opencontainers.image.version="$LIMESURVEY_VERSION" \
    org.opencontainers.image.description="LimeSurvey is an open-source tool for creating online surveys." \
    org.opencontainers.image.url="https://www.limesurvey.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/limesurvey"
