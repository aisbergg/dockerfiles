# aisberg/teamspeak-server aisberg/teamspeak-server:3.0.13.8
FROM ubuntu:17.10

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=1.4 \
    Comment="TeamSpeak is proprietary voice-over-Internet Protocol (VoIP) software for audio communication between users on a chat channel, much like a telephone conference call. (http://www.teamspeak.com/en/)"

ENV DEBIAN_FRONTEND=noninteractive \
    TEAMSPEAK_VERSION=3.0.13.8 \
    TEAMSPEAK_SHA256_CHECKSUM=460c771bf58c9a49b4be2c677652f21896b98a021d7fff286e59679b3f987a59

RUN apt-get update &&\
    apt-get install -y --no-install-recommends wget bzip2 &&\
    mkdir -p /opt/teamspeak &&\
    wget -q "http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux_amd64-${TEAMSPEAK_VERSION}.tar.bz2" -O /opt/teamspeak3-server.tar.bz2 &&\
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
