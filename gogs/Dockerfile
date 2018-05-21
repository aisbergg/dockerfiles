FROM golang:alpine as build

ENV GOGS_VERSION=0.11.43 \
    GOGS_SHA256_CHECKSUM=44ce25372fee4bf0cd3de54d7e7038ddc0079779c3ace7b4a0a53bb85853b14d

RUN apk --no-cache --no-progress add build-base linux-pam-dev &&\
    mkdir -p /usr/local/src /go/src/github.com/gogits/gogs /gogs &&\
    wget -q -O /usr/local/src/gogs.tar.gz "https://github.com/gogits/gogs/archive/v${GOGS_VERSION}.tar.gz"  &&\
    echo "$GOGS_SHA256_CHECKSUM  /usr/local/src/gogs.tar.gz" | sha256sum -c &&\
    tar -xf /usr/local/src/gogs.tar.gz -C /go/src/github.com/gogits/gogs --strip-components=1 &&\
    cd /go/src/github.com/gogits/gogs &&\
    go build -v -tags 'sqlite cert pam' &&\
    mv public scripts templates gogs /gogs &&\
    rm -r /go/src/github.com /usr/local/src/gogs.tar.gz

#-------------------------------------------------------------------------------

FROM aisberg/nginx

COPY --from=build /gogs /opt/gogs

RUN \
    # install required packages
    apk --update --no-cache --no-progress add \
        ca-certificates \
        git \
        linux-pam \
        openssh \
        openssh-keygen \
        shadow \
        sqlite \
        tzdata &&\
    chmod +rwX /opt/gogs &&\
    \
    # prepare working directories
    workdirs \
        /etc/ssh \
        /opt/gogs \
        /data/gogs

COPY provision /provision
COPY static /
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} +

VOLUME /data/gogs

# port for SSH
EXPOSE 2022

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="Gogs" \
    org.opencontainers.image.version="$GOGS_VERSION" \
    org.opencontainers.image.description="A self-hosted git service" \
    org.opencontainers.image.url="https://gogs.io/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/gogs" \
    org.opencontainers.image.created="$CREATED"
