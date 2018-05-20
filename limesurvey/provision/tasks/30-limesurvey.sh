#!/bin/bash
set -e

print_info "Configuring Lime Survey"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /data/www/*
    shopt -u dotglob
fi

# if Wordpress is not yet installed, copy it into web root
if [[ ! -f '/data/www/admin/admin.php' ]]; then
    print_info "No previous Lime Survey installation found, creating a new one"
    if ! is_dir_empty /data/www; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install Lime Survey!"
        exit 1
    fi

    tar xfz /usr/local/src/limesurvey.tar.gz -C /data/www --strip-components=1
    shopt -s dotglob
    chgrp 0 -R /data/www/*
    chmod g+rwX,o-rwx -R /data/www/*
    shopt -u dotglob

elif [[ $(bool "$AUTO_UPDATE" true) == "true" ]]; then
    INSTALLED_VERSION=$(php -r '$config = include "/data/www/application/config/version.php"; echo $config["versionnumber"];')
    # check if newer version is available to upgrade the current installation
    if version_greater "${LIMESURVEY_VERSION}" "$INSTALLED_VERSION" ; then
        print_info "Upgrading Lime Survey installation from $INSTALLED_VERSION to ${LIMESURVEY_VERSION}"

        tempdir="$(mktemp -d)"
        tar xfz /usr/local/src/limesurvey.tar.gz -C "$tempdir" --strip-components=1
        chgrp 0 -R "$tempdir"
        chmod g+rwX,o-rwx -R "$tempdir"

        rsync -rlD --delete \
            --exclude /application/config/config.php \
            --exclude /upload/ \
            --exclude /themes/ \
            --exclude /plugins/ \
            "$tempdir/" /data/www/

        for dir in plugins themes; do
            rsync -rlD --include "/$dir/" --exclude '/*' "$tempdir/"  /data/www/
        done
        shopt -s dotglob
        chgrp 0 -R /data/www/*
        chmod g+rwX,o-rwx -R /data/www/*
        shopt -u dotglob

        rm -rf "$tempdir"
    fi
fi
