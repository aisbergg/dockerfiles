##
## Build Stage
##

FROM aisberg/base-alpine:3.14 as build

ENV WDQS_BACKEND_VERSION=0.3.82 \
    JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/ \
    PATH=$JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN set -x \
    # install build dependencies
    && apk add --update --no-cache --no-progress --virtual .build-deps \
        git \
        maven \
        unzip \
        openjdk8 \
    \
    # download and build application
    # see: https://github.com/wikimedia/wikidata-query-rdf/blob/master/docs/getting-started.md
    && mkdir -p /usr/local/src/ /opt/wdqs-backend \
    && git clone -b "query-service-parent-$WDQS_BACKEND_VERSION" --depth 1 https://github.com/wikimedia/wikidata-query-rdf.git /usr/local/src/wdqs-backend \
    && cd /usr/local/src/wdqs-backend \
    && mvn package -Dmaven.test.skip=true \
    && tar xzf dist/target/service-$WDQS_BACKEND_VERSION-dist.tar.gz -C /opt/wdqs-backend --strip-components 1 \
    \
    # clean up
    && cd / \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /usr/local/src/wdqs-backend



##
## Final Stage
##

FROM aisberg/base-alpine:3.14

ENV INIT=supervisor

RUN set -x \
    # install runtime dependencies
    && apk update && apk add --no-progress --no-cache \
        bash \
        coreutils \
        curl \
        gettext \
        # works only with OpenJDK 8
        openjdk8 \
    \
    # clean up
    && rm -rf /var/cache/apk/*

COPY --from=build /opt/wdqs-backend /opt/wdqs-backend
COPY provision /provision

RUN set -x \
    # set correct permissions
    && find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} + \
    \
    # prepare working directories
    && workdirs \
        /opt/wdqs-backend \
        /container/db \
        /container/log

USER 999
EXPOSE 9999

LABEL org.opencontainers.image.title="Wikidata Query Service Backend" \
    org.opencontainers.image.description="Wikidata Query Service Backend" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/aisbergg/dockerfiles/wdqs-backend"
