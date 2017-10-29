# aisberg/mkdocs
FROM aisberg/nginx

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.1 \
    Comment="Generate statics websites from markdown to be used as a documentation"

RUN useradd -p /home/mkdocs -m -g www-data -s /bin/bash -u 999 mkdocs &&\
    apt-get update &&\
    apt-get install -y \
        cron \
        ssh-client \
        patch \
        git &&\
    pip install mkdocs &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision
