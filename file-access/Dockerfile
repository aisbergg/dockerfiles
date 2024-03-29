ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}${IMAGE_PREFIX:+/}aisberg/base-ubuntu:20.04

LABEL org.opencontainers.image.title="File Access" \
    org.opencontainers.image.description="Offers direct file access over SSH" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/aisbergg/dockerfiles/file-access"

ENV COMPOSER_VERSION=1.9.1 \
    COMPOSER_SHA256_CHECKSUM=7834fe8069d0a0c776275623365e70d7f681d5c4995d0f0e826a6e3823369afc

RUN set -x \
    \
    && apt-get update \
    && apt-get install -y \
        acl \
        bash-completion \
        cron \
        curl \
        git \
        iputils-ping \
        less \
        man \
        mysql-client \
        nano \
        openssh-server \
        php-cli \
        php-curl \
        php-fileinfo \
        php-gd \
        php-intl \
        php-json \
        php-mbstring \
        php-mysql \
        php-pear \
        php-redis \
        php-tokenizer \
        php-xml \
        renameutils \
        rsync \
        tmux \
        tree \
        vim \
        wget \
    && pip install -U ranger-fm \
    && pip install -U PyMySQL \
    && rm -rf /var/lib/apt/lists/* \
    \
    # create dirs
    && ln -sf /container/cron /var/spool/cron \
    && mkdir -p /run/sshd \
    && workdirs \
        /container/cron \
        /container/ssh \
    \
    # set PATH variable
    && echo PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.local/bin' > /etc/environment \
    \
    # git bash completion
    && wget -q https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O /etc/bash_completion.d/git-prompt.sh \
    # remote atom
    && wget -q https://raw.githubusercontent.com/aurora/rmate/master/rmate -O /usr/bin/ratom \
    && chmod +x /usr/bin/ratom \
    # PHP Composer
    && curl -fSL "https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar" -o /usr/bin/composer \
    && echo "$COMPOSER_SHA256_CHECKSUM  /usr/bin/composer" | sha256sum -c \
    && chmod +x /usr/bin/composer

COPY provision /provision
COPY static/ /

# setting the right file and dir permissions
RUN set -x \
    \
    && chmod 644 \
        /etc/bash.bashrc \
        /etc/pam.d/sshd \
        /etc/profile \
        /etc/profile.d/10-login-message.sh \
        /etc/ssh/moduli \
    && find /etc/skel/ -type d -exec chmod 770 {} + \
    && find /etc/skel/ -type f -exec chmod 660 {} +

VOLUME \
    /home \
    /container/cron \
    /container/ssh

EXPOSE 22
