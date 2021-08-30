##
## Build Stage
##

FROM node:14-alpine3.14 as build

# version 0.2.0 fails to build...
ARG WDQS_FRONTEND_VERSION=master

RUN set -x \
    # install general requirements
    && apk add --update --no-cache --no-progress --virtual .build-deps git \
    \
    # download and build
    && git clone -b "$WDQS_FRONTEND_VERSION" --depth 1 https://github.com/wikimedia/wikidata-query-gui.git /tmp/wdqs-frontend-src \
    && cd /tmp/wdqs-frontend-src \
    && npm install && npm run build \
    && cp -a ./build /tmp/wdqs-frontend \
    \
    # clean up
    && apk del .build-deps \
    && rm -rf /tmp/wdqs-frontend-src

##
## Final Stage
##

ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx

COPY --from=build /tmp/wdqs-frontend /container/www
COPY provision /provision

RUN set -x \
    # set correct permissions
    && find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} + \
    \
    # prepare working directories
    && workdirs /container/www

USER 999

LABEL org.opencontainers.image.title="Wikidata Query Service Frontend" \
    org.opencontainers.image.description="Wikidata Query Service Frontend" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/aisbergg/dockerfiles/wdqs-frontend"
