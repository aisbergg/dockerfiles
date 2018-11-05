FROM aisberg/nginx-node:11

ENV ETHERPAD_VERSION=1.7.0 \
    ETHERPAD_SHA256_CHECKSUM=40c60b9c2e8e82af1f4e41f0d88fc79902b49391cb2d00c02c9ee7938acfb9b5

RUN set -x \
    \
    # download Etherpad sources
    && curl -fSL "https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz" -o /usr/local/src/etherpad.tar.gz \
    && echo "$ETHERPAD_SHA256_CHECKSUM  /usr/local/src/etherpad.tar.gz" | sha256sum -c \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        rsync \
    \
    # prepare working directories
    && workdirs /container/etherpad

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/etherpad

USER 999

LABEL org.opencontainers.image.title="Etherpad" \
    org.opencontainers.image.version="$ETHERPAD_VERSION" \
    org.opencontainers.image.description="Etherpad is an open-source online editor providing collaborative editing in really real-time." \
    org.opencontainers.image.url="http://etherpad.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/etherpad"
