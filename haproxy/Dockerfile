FROM aisberg/base-alpine:3.7

ENV INIT=supervisor

RUN \
    # install required packages
    apk add --update --no-cache --no-progress \
        ca-certificates \
        libressl \
        haproxy &&\
    rm -rf /var/cache/apk/* &&\
    \
    # prepare directories and files
    workdirs \
        /container/tls \
        /container/cfg

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

EXPOSE 8080 8443 1936

ARG CREATED
LABEL org.opencontainers.image.title="HAProxy" \
    org.opencontainers.image.version="1.7.9" \
    org.opencontainers.image.description="HAProxy is a open-source high availability load balancer and proxy server for TCP and HTTP-based applications" \
    org.opencontainers.image.url="http://www.haproxy.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/haproxy" \
    org.opencontainers.image.created="$CREATED"
