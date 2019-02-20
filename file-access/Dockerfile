FROM aisberg/base-ubuntu:18.04

LABEL org.opencontainers.image.title="File Access" \
    org.opencontainers.image.description="Enables file access over SSH" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.source="https://github.com/Aisbergg/dockerfiles/file-access"

ENV COMPOSER_VERSION=1.8.4 \
    COMPOSER_SHA256_CHECKSUM=6faf282db067f0f7625a5a1d80f4ecd3228ccc9a0388aec1599824c610d5d4e3

RUN set -x \
    \
    && apt-get update \
    && apt-get install -y \
        acl \
        bash-completion \
        cron \
        curl \
        git \
        man \
        mysql-client \
        nano \
        openssh-server \
        php7.2-cli \
        php7.2-mysql \
        renameutils \
        rsync \
        tmux \
        tree \
        vim \
        wget \
    && pip install -U ranger-fm \
    && rm -rf /var/lib/apt/lists/* \
    \
    # create dirs
    && ln -sf /container/cron /var/spool/cron \
    && mkdir -p /run/sshd \
    && workdirs \
        /container/cron \
        /container/ssh \
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

ENV MYSQL_HOST=mysql \
    INIT=supervisor

VOLUME \
    /home \
    /container/cron \
    /container/ssh

EXPOSE 22
