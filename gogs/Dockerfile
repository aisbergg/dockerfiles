# aisberg/gogs aisberg/gogs:0.11.34
FROM aisberg/nginx

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.11 \
    Comment="A self-hosted git service. (https://gogs.io/)"

ENV GOGS_VERSION=0.11.34 \
    GOGS_SHA256_CHECKSUM=bfcd85f00ade51d7554aa99c0c5cb21735bc33e3d6d4bbdd156ed72a5d37d91f

RUN wget -q "https://github.com/gogits/gogs/releases/download/v${GOGS_VERSION}/linux_amd64.tar.gz" -O /usr/local/src/gogs.tar.gz &&\
    echo "$GOGS_SHA256_CHECKSUM /usr/local/src/gogs.tar.gz" | sha256sum -c &&\
    groupadd -g 999 git &&\
    useradd -p /home/git -m -g git -s /bin/bash -u 999 git &&\
    apt-get update &&\
    apt-get install -y git openssh-server sqlite3 &&\
    mkdir -p /var/run/sshd &&\
    tar -xf /usr/local/src/gogs.tar.gz -C /opt &&\
    rm -rf /usr/local/src/gogs.tar.gz /var/lib/apt/lists/*

COPY provision/ /provision

VOLUME /var/lib/gogs

# port for SSH
EXPOSE 22
