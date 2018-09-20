# aisberg/teamspeak-server aisberg/teamspeak-server:3.1.1
FROM ubuntu:18:04

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=1.5 \
    Comment="TeamSpeak is proprietary voice-over-Internet Protocol (VoIP) software for audio communication between users on a chat channel, much like a telephone conference call. (http://www.teamspeak.com/en/)"

ENV DEBIAN_FRONTEND=noninteractive \
    TEAMSPEAK_VERSION=3.1.1 \
    TEAMSPEAK_SHA256_CHECKSUM=c9403f7958e1bf1c5e5cf083641b1e02b06800158df543e09d9259c69181e873

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
