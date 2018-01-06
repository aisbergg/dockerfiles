# aisberg/mattermost aisberg/mattermost:3.4.0
FROM aisberg/nginx
MAINTAINER Andre Lehmann <aisberg@posteo.de>

ENV MATTERMOST_VERSION=3.4.0 \
    SHA256_CHECKSUM=c352f6c15466c35787bdb5207a6efe6b471513ccdd5b1f64a91a8bd09c3365da

RUN wget -q https://releases.mattermost.com/$MATTERMOST_VERSION/mattermost-team-$MATTERMOST_VERSION-linux-amd64.tar.gz -O /usr/local/src/mattermost.tar.gz &&\
    echo "$SHA256_CHECKSUM /usr/local/src/mattermost.tar.gz" | sha256sum -c &&\
    useradd -d /opt/mattermost --user-group -r mattermost &&\
    tar xfz /usr/local/src/mattermost.tar.gz -C /opt &&\
    chown mattermost:mattermost -R /opt/mattermost &&\
    rm /usr/local/src/mattermost.tar.gz

ENV CONTAINER_TYPE=mattermost \
    IMAGE_NAME=aisberg/mattermost \
    IMAGE_MAINTAINER="Andre Lehmann <aisberg@posteo.de>" \
    IMAGE_VERSION=2.0 \
    IMAGE_DESCRIPTION="Mattermost is an open-source communication platform for teams. (http://www.mattermost.org/)" \
    PERSISTENT_DIRS="/var/lib/mattermost;/etc/nginx/conf.d/mattermost"

COPY provision/ /provision

VOLUME /var/lib/mattermost \
    /etc/nginx/conf.d/mattermost

# expose port for inter node listening
EXPOSE 8075
