FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    TEAMSPEAK_VERSION=3.5.1 \
    TEAMSPEAK_SHA256_CHECKSUM=aa991a7b88f4d6e24867a98548b808c093771b85443f986c8adb09e78e41eb79

RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl &&\
    mkdir -p /opt/teamspeak &&\
    curl -fSL "http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux_amd64-${TEAMSPEAK_VERSION}.tar.bz2" -o /opt/teamspeak3-server.tar.bz2 &&\
    echo "$TEAMSPEAK_SHA256_CHECKSUM /opt/teamspeak3-server.tar.bz2" | sha256sum -c &&\
    tar xjf /opt/teamspeak3-server.tar.bz2 -C /opt/teamspeak --strip-components=1 &&\
    rm -rf /var/lib/apt/lists/* /opt/teamspeak3-server.tar.bz2

COPY entrypoint.sh /entrypoint.sh

VOLUME /var/lib/teamspeak-server

# teamspeak ports (voice, server query, file transfer)
EXPOSE 9987/udp \
    10011 \
    30033

ENTRYPOINT ["bash", "/entrypoint.sh"]

LABEL org.opencontainers.image.title="TeamSpeak" \
    org.opencontainers.image.version="$TEAMSPEAK_VERSION" \
    org.opencontainers.image.description="TeamSpeak is proprietary voice-over-Internet Protocol (VoIP) software for audio communication between users on a chat channel, much like a telephone conference call." \
    org.opencontainers.image.url="http://www.teamspeak.com/en/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/teamspeak-server"
