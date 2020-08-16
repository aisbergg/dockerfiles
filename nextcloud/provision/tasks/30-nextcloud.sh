#!/bin/bash
set -eo pipefail

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
if [[ ! -f /container/www/version.php || -f /container/www/.installation-in-progess ]]; then
    if ! is_dir_empty /container/www || [[ -f /container/www/.installation-in-progess ]]; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install Nextcloud!"
        exit 1
    fi
    print_info "No previous Nextcloud installation found, creating a new one"

    pushd /container/www >/dev/null
    # create lockfile
    touch .installation-in-progess

    # create files
    tar xjf /usr/local/src/nextcloud.tar.bz2 --strip-components=1
    rm -rf updater
    mkdir -p \
        custom_apps \
        data \
        skeleton

    # set permissions
    shopt -s dotglob
    chmod g+rwX,o-rwx -R ./*
    chgrp root -R ./*
    chmod u+x,g+x ./occ
    shopt -u dotglob

    rm .installation-in-progess
    popd >/dev/null

# check if the installed version can be upgraded
elif [[ $(bool "$NEXTCLOUD_AUTO_UPDATE" "true") == "true" || -f /container/www/.update-in-progess ]]; then
    INSTALLED_VERSION="$(php -r 'require "/container/www/version.php"; echo $OC_VersionString;')"
    if version_greater "$NEXTCLOUD_VERSION" "$INSTALLED_VERSION" || [[ -f /container/www/.update-in-progess ]]; then
        # upgrade installation without destroying the userdata
        print_info "Updating Nextcloud ($INSTALLED_VERSION --> $NEXTCLOUD_VERSION)"

        pushd /container/www >/dev/null
        # create lockfile
        touch .update-in-progess

        tempdir="$(mktemp -d)"
        tar xjf /usr/local/src/nextcloud.tar.bz2 -C "$tempdir" --strip-components=1

        rsync -rlD --delete \
            --exclude /config/ \
            --exclude /custom_apps/ \
            --exclude /data/ \
            --exclude /skeleton/ \
            --exclude /themes/ \
            --exclude /.update-in-progess \
            --exclude /favicon.ico \
            "$tempdir/" ./

        rsync -rlD --include "/themes/" --exclude '/*' "$tempdir/" ./

        shopt -s dotglob
        chmod g+rwX,o-rwx -R ./* || true
        chgrp root -R ./* || true
        chmod u+x,g+x ./occ || true
        shopt -u dotglob

        php occ app:list | sed -n "/Disabled:/,//p" > .apps-before

        touch .update-in-progess-phase2

        rm -rf $tempdir .update-in-progess
        popd >/dev/null
    fi

    unset INSTALLED_VERSION
fi
