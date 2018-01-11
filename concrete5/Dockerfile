# aisberg/concrete5 aisberg/concrete5:8.3.1
FROM aisberg/nginx-php5

LABEL Author="Andre Lehmann <aisberg@posteo.de>" \
    Version=2.4 \
    Comment="Concrete5 is an open-source content management system (CMS). http://www.concrete5.org/)"

ENV CONCRETE5_VERSION=8.3.1 \
    CONCRETE5_SHA256_CHECKSUM=1de40d492dc52613e008dd6ef884f5fe3a682072d38b18fde8c977d066db66aa

RUN wget -q "https://www.concrete5.org/download_file/-/view/99963/concrete5-${CONCRETE5_VERSION}.zip" -O /usr/local/src/concrete5.zip &&\
    echo "$CONCRETE5_SHA256_CHECKSUM /usr/local/src/concrete5.zip" | sha256sum -c

COPY provision/ /provision

VOLUME /var/www/concrete5 \
    /etc/nginx/conf.d/concrete5
