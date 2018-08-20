#!/bin/bash
set -e

print_info "Configuring Lime Survey"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# if Lime Survey is not yet installed, copy it into web root
if [[ ! -f '/container/www/admin/admin.php' ]]; then
    print_info "No previous Lime Survey installation found, creating a new one"
    if ! is_dir_empty /container/www; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install Lime Survey!"
        exit 1
    fi

    tar xzf /usr/local/src/limesurvey.tar.gz -C /container/www --strip-components=1
    shopt -s dotglob
    chgrp 0 -R /container/www/*
    chmod g+rwX,o-rwx -R /container/www/*
    shopt -u dotglob

elif [[ $(bool "$AUTO_UPDATE" true) == "true" ]]; then
    INSTALLED_VERSION=$(php -r '$config = include "/container/www/application/config/version.php"; echo $config["versionnumber"];')
    # check if newer version is available to upgrade the current installation
    if version_greater "${LIMESURVEY_VERSION}" "$INSTALLED_VERSION" ; then
        print_info "Upgrading Lime Survey ($INSTALLED_VERSION --> ${LIMESURVEY_VERSION})"

        tempdir="$(mktemp -d)"
        tar xzf /usr/local/src/limesurvey.tar.gz -C "$tempdir" --strip-components=1
        chgrp 0 -R "$tempdir"
        chmod g+rwX,o-rwx -R "$tempdir"

        rsync -rlD --delete \
            --exclude /application/config/config.php \
            --exclude /upload/ \
            --exclude /themes/ \
            --exclude /plugins/ \
            "$tempdir/" /container/www/

        for dir in plugins themes; do
            rsync -rlD --include "/$dir/" --exclude '/*' "$tempdir/"  /container/www/
        done
        shopt -s dotglob
        chgrp 0 -R /container/www/*
        chmod g+rwX,o-rwx -R /container/www/*
        shopt -u dotglob

        rm -rf "$tempdir"
    fi
fi
