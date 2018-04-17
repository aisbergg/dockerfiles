FROM aisberg/base-alpine:3.7

ENV INIT=supervisor

RUN apk add --update --no-cache --no-progress \
        murmur \
        openssl \
        tzdata &&\
    workdirs \
        /var/lib/mumble-server \
        /etc/ssl/private

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

EXPOSE 64738 64738/udp

ARG CREATED
LABEL org.opencontainers.image.title="Nginx" \
    org.opencontainers.image.version="1.2.19" \
    org.opencontainers.image.description="Mumble is an open source, low-latency, high quality voice chat software primarily intended for use while gaming." \
    org.opencontainers.image.url="https://wiki.mumble.info/wiki/Main_Page" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/mumble-server" \
    org.opencontainers.image.created="$CREATED"
