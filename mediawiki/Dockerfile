FROM aisberg/nginx-php7

ENV MEDIAWIKI_MAJOR=1.31 \
    MEDIAWIKI_MINOR=0 \
    MEDIAWIKI_PGP_KEY_ID=41B2ABE817ADD3E52BDA946F72BC1C5D23107F8A \
    MEDIAWIKI_MATH_EXTENSION_FILE_NAME=Math-REL1_31-a1263db.tar.gz \
    MEDIAWIKI_MATH_EXTENSION_SHA256_CHECKSUM=e9a637221781eb92c7edc40907e23e4a7319e42a65dd75ef476fe99e7cf409d2

RUN set -x \
    \
    # download MediaWiki source
    && curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR}/mediawiki-${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}.tar.gz" -o /usr/local/src/mediawiki.tar.gz \
    && curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR}/mediawiki-${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}.tar.gz.sig" -o /usr/local/src/mediawiki.tar.gz.sig \
    && ( gpg --keyserver ipv4.pool.sks-keyservers.net --keyserver-options timeout=10 --recv-keys "$MEDIAWIKI_PGP_KEY_ID" \
        || gpg --keyserver pgp.mit.edu --keyserver-options timeout=10 --recv-keys "$MEDIAWIKI_PGP_KEY_ID" \
        || gpg --keyserver keyserver.pgp.com --keyserver-options timeout=10 --recv-keys "$MEDIAWIKI_PGP_KEY_ID" ) \
    && gpg --verify /usr/local/src/mediawiki.tar.gz.sig /usr/local/src/mediawiki.tar.gz \
    && rm /usr/local/src/mediawiki.tar.gz.sig \
    \
    # install general requirements for MediaWiki
    && apk update \
    && apk add --no-progress \
        diffutils \
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
    # install requirements for the Math extension
    && curl -fSL "https://extdist.wmflabs.org/dist/extensions/${MEDIAWIKI_MATH_EXTENSION_FILE_NAME}" -o && /usr/local/src/mediawiki-extension-math.tar.gz \
    && echo "$MEDIAWIKI_MATH_EXTENSION_SHA256_CHECKSUM  /usr/local/src/mediawiki-extension-math.tar.gz" | && sha256sum -c \
    && apk add --no-progress \
        texlive \
    && apk add --no-progress --virtual .build-deps \
        binutils \
        gcc \
        make \
        musl-dev \
        ocaml \
    && tempdir="$(mktemp -d)" \
    && tar xzf /usr/local/src/mediawiki-extension-math.tar.gz -C "$tempdir" \
    && cd "$tempdir/Math" \
    && make \
    && rm math/*.o texvccheck/*.o \
    && chmod g+rwX,o-rwx -R "$tempdir" \
    && tar pczf /usr/local/src/mediawiki-extension-math.tar.gz -C "$tempdir" "Math/" \
    && cd / && rm -rf "$tempdir" \
    && apk del .build-deps \
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

ARG CREATED
LABEL org.opencontainers.image.title="MediaWiki" \
    org.opencontainers.image.version="${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" \
    org.opencontainers.image.description="MediaWiki is an open-source web application for creating a wiki." \
    org.opencontainers.image.url="https://www.mediawiki.org/wiki/MediaWiki" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/mediawiki" \
    org.opencontainers.image.created="$CREATED"
