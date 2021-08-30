ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/nginx-php7

ENV MATTERMOST_VERSION=5.2.1 \
    MATTERMOST_SHA256_CHECKSUM=890deaa3706b2965e4fe04ad88bc99c1f003f98773dd057b605b13570d33371d

RUN set -x \
    \
    # install mattermost
    && curl -fSL "https://releases.mattermost.com/${MATTERMOST_VERSION}/mattermost-team-${MATTERMOST_VERSION}-linux-amd64.tar.gz" -o /usr/local/src/mattermost.tar.gz \
    && echo "$MATTERMOST_SHA256_CHECKSUM  /usr/local/src/mattermost.tar.gz" | sha256sum -c \
    && tar xfz /usr/local/src/mattermost.tar.gz -C /opt \
    && chmod g+rwX -R /opt/mattermost \
    && rm -f /usr/local/src/mattermost.tar.gz \
    \
    # prepare working directories
    && workdirs /container/mattermost

COPY provision /provision
RUN find /provision -type f -exec chmod 0664 {} + \
    && find /provision -type d -exec chmod 0775 {} +

VOLUME /container/mattermost

# expose port for inter node listening
EXPOSE 8075

USER 999

LABEL org.opencontainers.image.title="Mattermost" \
    org.opencontainers.image.version="$MATTERMOST_VERSION" \
    org.opencontainers.image.description="Mattermost is an open-source communication platform for teams." \
    org.opencontainers.image.url="http://www.mattermost.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/mattermost"
