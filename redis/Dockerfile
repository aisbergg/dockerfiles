# aisberg/redis
FROM ubuntu:17.10

# included from template-ubuntu ------------------------------------------------
ARG language=en_US.UTF-8

ENV TERM=xterm \
    DEBIAN_FRONTEND=noninteractive

COPY Templer.tar.gz /tmp/Templer.tar.gz
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh &&\
    echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends &&\
    echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends &&\
    apt-get update &&\
    `#----- generate locales -----#` &&\
    apt-get install -y locales &&\
    sed -i -e "s/# $language/$language/" /etc/locale.gen &&\
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale language=$language &&\
    `#----- install essential packages -----#` &&\
    apt-get install -y \
        bzip2 \
        ca-certificates \
        dirmngr \
        iputils-ping \
        nano \
        python-pip \
        python-setuptools \
        python-yaml \
        python2.7 \
        supervisor \
        unzip \
        vim.tiny \
        wget \
        xz-utils &&\
    `#----- install templating engine -----#` &&\
    unset http_proxy https_proxy &&\
    pip install /tmp/Templer.tar.gz &&\
    `#----- cleanup -----#` &&\
    rm -rf /tmp/*

ENV LANG=$language \
    LC_ALL=$language

ENTRYPOINT ["/entrypoint.sh", "container_start"]
#-------------------------------------------------------------------------------

LABEL maintainer="Andre Lehmann <aisberg@posteo.de>" \
    version=1.0 \
    description="Redis is an open source, in-memory data structure store, used as a database, cache and message broker. (https://redis.io)"

RUN apt-get update &&\
    apt-get install -y redis-server &&\
    rm -rf /var/lib/apt/lists/* &&\
    mkdir -p /var/run/redis &&\
    chown redis:redis /var/run/redis

COPY provision/ /provision

VOLUME /var/lib/redis

EXPOSE 6379/tcp