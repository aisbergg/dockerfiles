# aisberg/grav-webdav
FROM aisberg/grav

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 1FCD77DD0DBEF5699AD2610160EE47FBAD3DD469 &&\
    echo "deb http://ppa.launchpad.net/nextcloud-devs/client/ubuntu zesty main " > /etc/apt/sources.list.d/nextcloud.conf &&\
    apt-get update && apt-get install -y cron nextcloud-client &&\
    rm -rf /var/lib/apt/lists/*

COPY provision/ /provision
