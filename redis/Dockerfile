FROM aisberg/base-alpine:3.7

RUN set -x \
    \
    # install required packages
    && apk add --update --no-cache --no-progress \
        libressl \
        redis\
    \
    # prepare working directories
    && workdirs \
        /container/redis \
        /etc/redis

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} +\
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/redis

EXPOSE 6379/tcp

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="Redis" \
    org.opencontainers.image.version="4.0.11" \
    org.opencontainers.image.description="Redis is an open source, in-memory data structure store, used as a database, cache and message broker" \
    org.opencontainers.image.url="https://redis.io" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/redis" \
    org.opencontainers.image.created="$CREATED"
