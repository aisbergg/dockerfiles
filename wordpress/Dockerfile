FROM aisberg/nginx-php7

ENV WP_CLI_VERSION=2.1.0 \
    WP_CLI_PGP_KEY_ID=63AF7AA15067C05616FDDD88A3A2E8F226F0BC06

RUN set -x \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        less \
        mariadb-client \
        php7-apcu \
        php7-gd \
        php7-mysqli \
        php7-opcache \
        php7-tokenizer \
    && apk add --update --no-cache --no-progress --repository ${ALPINE_MIRROR}edge/main/ \
        ghostscript-fonts \
        imagemagick \
        imagemagick-libs \
        shared-mime-info \
    \
    # install WP-CLI
    && curl -fSL "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar" -o /usr/bin/wp-cli.phar \
    && curl -fSL "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar.asc" -o /tmp/wp-cli.phar.asc \
    && ( gpg --batch --keyserver ipv4.pool.sks-keyservers.net --keyserver-options timeout=10 --recv-keys "$WP_CLI_PGP_KEY_ID" \
        || gpg --batch --keyserver pgp.mit.edu --keyserver-options timeout=10 --recv-keys "$WP_CLI_PGP_KEY_ID" \
        || gpg --batch --keyserver keyserver.pgp.com --keyserver-options timeout=10 --recv-keys "$WP_CLI_PGP_KEY_ID" ) \
    && gpg --batch --verify /tmp/wp-cli.phar.asc /usr/bin/wp-cli.phar \
    && rm /tmp/wp-cli.phar.asc \
    && ln -sf /usr/bin/wp-cli.phar /usr/bin/wp-cli \
    && ln -sf /usr/bin/wp-cli.phar /usr/bin/wp \
    && chmod +x /usr/bin/wp-cli.phar \
    \
    # prepare working directories
    && workdirs \
        /container/www \
        /etc/ImageMagick-7

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/www

USER 999

LABEL org.opencontainers.image.title="Wordpress" \
    org.opencontainers.image.description="Wordpress is an open-source content management system (CMS)." \
    org.opencontainers.image.url="https://wordpress.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/wordpress"
