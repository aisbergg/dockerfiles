# aisberg/letsencrypt
FROM ubuntu:17.04
MAINTAINER Andre Lehmann <aisberg@posteo.de>

RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        python2.7 \
        python-cryptography \
        python-openssl \
        python-yaml \
        cron \
        certbot \
        letsencrypt &&\
    rm -rf /var/lib/apt/lists/* &&\
    echo "0 3 * * * python2 /run_certbot.py" | crontab -u root -

COPY run_certbot.py /run_certbot.py

VOLUME /var/www/letsencrypt-challenge-response \
    /etc/letsencrypt \
    /var/log/letsencrypt

ENTRYPOINT python2 /run_certbot.py && /usr/sbin/cron -f
