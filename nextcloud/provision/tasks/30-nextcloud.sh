#!/bin/bash
set -e

print_info "Configuring Nextcloud"

if [[ -z DOMAINNAMES ]]; then
    print_error "You have to specify at least one domainname"
    exit 1
fi

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# create a new Nextcloud installation
if [[ ! -f "/container/www/version.php" ]]; then
    if ! is_dir_empty /container/www; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Nextcloud!"
        exit 1
    fi
    print_info "No previous Nextcloud installation found, creating a new one"

    # create files
    tar xjf /usr/local/src/nextcloud.tar.bz2 -C /container/www --strip-components=1
    rm -rf /container/www/updater
    mkdir -p \
        /container/www/custom_apps \
        /container/www/data \
        /container/www/skeleton

    # set permissions
    shopt -s dotglob
    chmod g+rwX,o-rwx -R /container/www/* &&\
    chgrp root -R /container/www/*
    shopt -u dotglob
    chmod +x /container/www/occ

# check if the installed version can be upgraded
elif [[ $(bool "$AUTO_UPDATE" "true") == "true" ]]; then
    INSTALLED_VERSION="$(php -r 'require "/container/www/version.php"; echo $OC_VersionString;')"
    if version_greater "$NEXTCLOUD_VERSION" "$INSTALLED_VERSION" ; then
        # upgrade installation without destroying the userdata
        print_info "Upgrading Nextcloud ($INSTALLED_VERSION --> $NEXTCLOUD_VERSION)"

        tempdir="$(mktemp -d)"
        tar xjf /usr/local/src/nextcloud.tar.bz2 -C "$tempdir" --strip-components=1

        rsync -rlD --delete \
            --exclude /config/ \
            --exclude /custom_apps/ \
            --exclude /data/ \
            --exclude /skeleton/ \
            --exclude /themes/ \
            --exclude /.user.ini \
            --exclude /favicon.ico \
            "$tempdir/" /container/www/

        rsync -rlD --include "/themes/" --exclude '/*' "$tempdir/"  /container/www/

        shopt -s dotglob
        chmod g+rwX,o-rwx -R /container/www/* &&\
        chgrp root -R /container/www/*
        shopt -u dotglob

        touch /container/www/.needs-upgrade

        rm -r $tempdir
    fi

    unset INSTALLED_VERSION
fi
