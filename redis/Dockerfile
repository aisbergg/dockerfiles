# aisberg/redis
FROM ubuntu:17.10

LABEL maintainer="Andre Lehmann <aisberg@posteo.de>" \
    version=1.0 \
    description="Redis is an open source, in-memory data structure store, used as a database, cache and message broker. (https://redis.io)"

# included from template-ubuntu ------------------------------------------------
ENV TERM=xterm \
    DEBIAN_FRONTEND=noninteractive

COPY Templer.tar.gz /tmp/Templer.tar.gz
COPY entrypoint.sh /entrypoint.sh

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends &&\
    echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends &&\
    apt-get update &&\
    apt-get install -y \
        python2.7 \
        python-setuptools \
        python-pip \
        python-yaml \
        supervisor \
        dirmngr \
        vim.tiny \
        nano \
        ca-certificates \
        wget \
        unzip \
        xz-utils \
        bzip2 \
        iputils-ping &&\
    `#----- install templating engine -----#` &&\
    pip install /tmp/Templer.tar.gz &&\
    chmod +x /entrypoint.sh &&\
    rm -rf /tmp/*

ENTRYPOINT ["/entrypoint.sh", "container_start"]
#-------------------------------------------------------------------------------

RUN apt-get update &&\
    apt-get install -y redis-server &&\
    rm -rf /var/lib/apt/lists/* &&\
    mkdir -p /var/run/redis &&\
    chown redis:redis /var/run/redis

COPY provision/ /provision

VOLUME /var/lib/redis

EXPOSE 6379/tcp