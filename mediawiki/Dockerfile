# aisberg/mediawiki aisberg/mediawiki:1.30.0
FROM aisberg/nginx-php7

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.4 \
    Comment="MediaWiki is an open-source web application for creating a wiki. (https://www.mediawiki.org/wiki/MediaWiki)"

ENV MEDIAWIKI_MAJOR=1.30 \
    MEDIAWIKI_MINOR=0 \
    PGP_KEY_ID=41B2ABE817ADD3E52BDA946F72BC1C5D23107F8A

RUN wget -q "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR}/mediawiki-${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}.tar.gz" -O /usr/local/src/mediawiki.tar.gz &&\
    wget -q "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR}/mediawiki-${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}.tar.gz.sig" -O /usr/local/src/mediawiki.tar.gz.sig &&\
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $PGP_KEY_ID &&\
    gpg --verify /usr/local/src/mediawiki.tar.gz.sig /usr/local/src/mediawiki.tar.gz &&\
    apt-get update &&\
    apt-get install -y \
        php-pear \
        imagemagick \
        graphviz \
        patch &&\
    rm -rf /var/lib/apt/lists/* &&\
    pear install Net_SMTP mail Auth_SASL2-beta mail_mime

COPY provision/ /provision

VOLUME /var/www/mediawiki \
    /etc/nginx/conf.d/mediawiki
