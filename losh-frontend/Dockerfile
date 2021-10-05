##
## Build Stage
##

FROM node:16-alpine3.14 as build

# install build requirements
RUN apk add --update --no-cache --no-progress \
        alpine-sdk \
        autoconf \
        automake \
        libtool \
        nasm \
        util-linux

ARG REPOSITORY_URL=https://github.com/wmde/LOSH-Frontend.git
ARG VERSION=main
ARG PATH_PREFIX=""

RUN set -x \
    # download and build
    && git clone -b "$VERSION" --depth 1 "$REPOSITORY_URL" /tmp/losh-frontend-src \
    && cd /tmp/losh-frontend-src \
    && yarn install --production \
    # production installation lacks the gatsby-plugin-eslint package, which is required for building the project
    && yarn add gatsby-plugin-eslint \
    # disable telemetry for this automated build
    && yarn run gatsby telemetry --disable \
    && PATH_PREFIX="$PATH_PREFIX" yarn run gatsby build --prefix-paths \
    && cp -a ./public /tmp/losh-frontend \
    \
    # clean up
    && rm -rf /tmp/losh-frontend-src

##
## Final Stage
##

ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx

COPY --from=build /tmp/losh-frontend /container/www
COPY provision /provision

RUN set -x \
    # set correct permissions
    && find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} + \
    \
    # prepare working directories
    && workdirs /container/www

USER 999

LABEL org.opencontainers.image.title="LOSH Frontend" \
    org.opencontainers.image.description="Frontend for Libary of Open Source Hardware Project" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/aisbergg/dockerfiles/losh-frontend"
