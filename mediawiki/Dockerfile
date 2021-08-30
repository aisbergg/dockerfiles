ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx-php7

# latest version can be found here https://www.mediawiki.org/wiki/Special:MyLanguage/Download
ENV MEDIAWIKI_MAJOR=1.36 \
    MEDIAWIKI_MINOR=1 \
    MEDIAWIKI_SHA256_CHECKSUM=e6698b19af16274e5ec2bfd36b890996cfa9f3617d2ec81761f12854fa50ad7a

RUN set -x \
    \
    # download MediaWiki source
    && curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR}/mediawiki-${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}.tar.gz" -o /usr/local/src/mediawiki.tar.gz \
    && echo "$MEDIAWIKI_SHA256_CHECKSUM  /usr/local/src/mediawiki.tar.gz" | sha256sum -c \
    \
    # install general requirements for MediaWiki
    # see https://www.mediawiki.org/wiki/Manual:Installation_requirements
    && apk add --update --no-progress \
        diffutils \
        git \
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
        php7-redis \
        php7-session \
        php7-simplexml \
        php7-tokenizer \
        php7-xml \
        php7-xmlwriter \
        rsync \
    && pear channel-update pear.php.net \
    && pear install Net_SMTP mail Auth_SASL2-beta mail_mime \
    \
    # install requirements for processing images
    && apk add --no-progress \
        imagemagick \
        imagemagick-libs \
        shared-mime-info \
    \
    # install requirements for the GraphViz extension
    && apk add --no-progress \
        ghostscript-fonts \
        graphviz \
    && apk add --no-progress --virtual .ms-fonts-deps \
        msttcorefonts-installer \
    && /usr/bin/update-ms-fonts \
    && fc-cache -f \
    && apk del .ms-fonts-deps \
    \
    # install requirements for the PdfHandler extension
    && apk add --no-progress \
        ghostscript \
        poppler-utils \
    \
    # cleanup
    && rm -rf /var/cache/apk/* \
    \
    # prepare working directories
    && workdirs \
        /etc/ImageMagick-7 \
        /container/www

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

USER 999

VOLUME /container/www

LABEL org.opencontainers.image.title="MediaWiki" \
    org.opencontainers.image.version="${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" \
    org.opencontainers.image.description="MediaWiki is an open-source web application for creating a wiki." \
    org.opencontainers.image.url="https://www.mediawiki.org/wiki/MediaWiki" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/aisbergg/dockerfiles/mediawiki"
