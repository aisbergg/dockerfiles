FROM aisberg/nginx-php7

ENV MEDIAWIKI_MAJOR=1.30 \
    MEDIAWIKI_MINOR=0 \
    MEDIAWIKI_PGP_KEY_ID=41B2ABE817ADD3E52BDA946F72BC1C5D23107F8A

RUN \
    # download MediaWiki source
    curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR}/mediawiki-${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}.tar.gz" -o /usr/local/src/mediawiki.tar.gz &&\
    curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR}/mediawiki-${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}.tar.gz.sig" -o /usr/local/src/mediawiki.tar.gz.sig &&\
    ( gpg --keyserver ipv4.pool.sks-keyservers.net --keyserver-options timeout=10 --recv-keys "$MEDIAWIKI_PGP_KEY_ID" \
        || gpg --keyserver pgp.mit.edu --keyserver-options timeout=10 --recv-keys "$MEDIAWIKI_PGP_KEY_ID" \
        || gpg --keyserver keyserver.pgp.com --keyserver-options timeout=10 --recv-keys "$MEDIAWIKI_PGP_KEY_ID" ) &&\
    gpg --verify /usr/local/src/mediawiki.tar.gz.sig /usr/local/src/mediawiki.tar.gz &&\
    rm /usr/local/src/mediawiki.tar.gz.sig &&\
    \
    # install required packages
    apk add --update --no-cache --no-progress \
        diffutils \
        graphviz \
        imagemagick \
        imagemagick-libs \
        php7-apcu \
        php7-curl \
        php7-fileinfo \
        php7-gd \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mysqli \
        php7-opcache \
        php7-openssl \
        php7-pear \
        php7-session \
        php7-simplexml \
        php7-xml \
        php7-xmlwriter \
        php7-tokenizer \
        rsync \
        shared-mime-info &&\
    pear channel-update pear.php.net &&\
    pear install Net_SMTP mail Auth_SASL2-beta mail_mime &&\
    \
    # prepare working directories
    workdirs \
        /etc/ImageMagick-7 \
        /data/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

USER 999

VOLUME /data/www

ARG CREATED
LABEL org.opencontainers.image.title="MediaWiki" \
    org.opencontainers.image.version="${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" \
    org.opencontainers.image.description="MediaWiki is an open-source web application for creating a wiki." \
    org.opencontainers.image.url="https://www.mediawiki.org/wiki/MediaWiki" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/mediawiki" \
    org.opencontainers.image.created="$CREATED"
