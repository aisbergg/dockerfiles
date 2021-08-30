FROM golang:alpine as build

ENV GITEA_VERSION=1.8.2

RUN apk --no-cache --no-progress add build-base git \
    && git clone --branch v$GITEA_VERSION --single-branch --depth 1 https://github.com/go-gitea/gitea.git /go/src/code.gitea.io/gitea \
    && cd /go/src/code.gitea.io/gitea \
    && TAGS="bindata sqlite" make clean generate build

#-------------------------------------------------------------------------------

ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx

RUN set -x \
    \
    # install required packages
    && apk --update --no-cache --no-progress add \
        ca-certificates \
        git \
        openssh \
        openssh-keygen \
        shadow \
        sqlite \
        tzdata \
    \
    # prepare git user
    && usermod -l git cu \
    \
    # prepare working directories
    && workdirs \
        /etc/ssh \
        /container/gitea

COPY provision /provision
COPY static /
COPY --from=build /go/src/code.gitea.io/gitea/gitea /usr/bin/gitea
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/gitea

# port for SSH
EXPOSE 2022

USER 999

LABEL org.opencontainers.image.title="Gitea" \
    org.opencontainers.image.version="1.7.3" \
    org.opencontainers.image.description="A self-hosted git service" \
    org.opencontainers.image.url="https://gitea.io/en-us/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/gitea"
