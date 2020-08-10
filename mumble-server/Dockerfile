FROM aisberg/base-alpine:3.12

ENV INIT=supervisor

RUN set -x \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        icu-libs \
        libressl \
        murmur \
        tzdata \
    \
    # prepare working directories
    && workdirs \
        /container/mumble-server \
        /container/tls

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

EXPOSE 64738 64738/udp

USER 999

LABEL org.opencontainers.image.title="Mumble Server" \
    org.opencontainers.image.version="1.3.0-r2" \
    org.opencontainers.image.description="Mumble is an open source, low-latency, high quality voice chat software primarily intended for use while gaming." \
    org.opencontainers.image.url="https://wiki.mumble.info/wiki/Main_Page" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/mumble-server"
