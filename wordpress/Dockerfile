FROM aisberg/nginx-php7

ENV WORDPRESS_VERSION=4.9.5 \
    WORDPRESS_SHA256_CHECKSUM=a1664b259755021adbfbe5e8f7fd78a98c015e92e1f985258abed19f759822cb

RUN wget -q "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" -O /usr/local/src/wordpress.tar.gz &&\
    echo "$WORDPRESS_SHA256_CHECKSUM  /usr/local/src/wordpress.tar.gz" | sha256sum -c &&\
    `#---- install imagemagick ----#` &&\
    apk add --update --no-cache --no-progress \
        graphviz \
        imagemagick \
        imagemagick-libs \
        shared-mime-info &&\
    workdirs \
        /etc/ImageMagick-7 \
        /var/www/wordpress

# RUN wget -q "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" -O /usr/local/src/wordpress.tar.gz &&\
#     echo "$WORDPRESS_SHA256_CHECKSUM  /usr/local/src/wordpress.tar.gz" | sha256sum -c &&\
#     `#---- install imagemagick ----#` &&\
#     apt-get update &&\
#     apt-get install -y \
#         ghostscript \
#         graphviz \
#         gsfonts \
#         imagemagick \
#         libmagickcore-6.q16-3-extra \
#         netpbm \
#         shared-mime-info &&\
#     rm -rf /var/lib/apt/lists/*

COPY provision /provision

VOLUME /var/www/wordpress

USER 999

ARG CREATED
LABEL org.opencontainers.image.title="Wordpress" \
    org.opencontainers.image.version="$WORDPRESS_VERSION" \
    org.opencontainers.image.description="Wordpress is an open-source content management system (CMS)." \
    org.opencontainers.image.url="https://wordpress.org/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/wordpress" \
    org.opencontainers.image.created="$CREATED"
