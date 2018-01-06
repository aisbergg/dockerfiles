#!/bin/bash

# exit on errors
set -e

printINFO "Configuring Roundcube"

# create random string to be used as des_key
export DES_KEY="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%' | head -c40; echo "")"

# removing all files before installing
if [[ `standardiseBool "$CLEAN_INSTALLATION" False` == "True" ]]; then
    printINFO "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/roundcube/*
    shopt -u dotglob
fi

# if Roundcube is not yet installed, copy it into web root
if [ ! -f '/var/www/roundcube/index.php' ]; then
    printINFO "No previous Roundcube installation found, creating a new one"
    if ! isDirEmpty /var/www/roundcube; then
        printERROR "Install dir is not empty! Make sure the target dir is empty before trying to install a new Roundcube!"
        exit 1
    fi

    tar xfz /usr/local/src/roundcube.tar.gz -C /var/www/roundcube --strip-components=1

    # set flag to complete installation after config generation
    export COMPLETE_INSTALLATION=True

    # set right permissions
    chown -R www-data:www-data /var/www/roundcube

# check if the installed version can be upgraded
elif [[ `standardiseBool "$AUTO_UPDATE"` == "True" ]]; then
    INSTALLED_VERSION="$(cat /var/www/roundcube/index.php | grep "Version" | grep -oE '[0123456789\.]+')"
    if [ "$INSTALLED_VERSION" != "$ROUNDCUBE_VERSION" ]; then
        # upgrade installation without destroying the userdata
        printINFO "Upgrading Roundcube installation from $INSTALLED_VERSION to ${ROUNDCUBE_VERSION}"

        tar -xf /usr/local/src/roundcube.tar.gz -C /tmp
        cd /tmp/roundcubemail-${ROUNDCUBE_VERSION}

        # update files
        php ./bin/installto.sh /var/www/roundcube
        cd /var/www/roundcube

        # update database
        php ./bin/update.sh

        # update the fulltext index for all contacts
        php ./bin/indexcontacts.sh
    fi

    unset INSTALLED_VERSION
fi
