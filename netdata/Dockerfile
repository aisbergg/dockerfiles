FROM netdata/netdata:v1.11.1

RUN set -x \
    \
    # install packages
    && apk add --update --no-cache --no-progress \
        ca-certificates \
        iproute2 \
        msmtp \
        smartmontools \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        mariadb-connector-c-dev \
        py2-pip \
        python2-dev \
        shadow \
    && pip install mysqlclient \
    && pip install docker \
    \
    # add netdata user to docker group
    && groupadd -r -g 991 docker \
    && usermod -a -G docker netdata \
    \
    # cleanup
    && apk del .build-deps

COPY /entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

LABEL org.opencontainers.image.title="Netdata" \
    org.opencontainers.image.version="1.11.1" \
    org.opencontainers.image.description="Real-time performance monitoring" \
    org.opencontainers.image.url="https://my-netdata.io" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/netdata"
