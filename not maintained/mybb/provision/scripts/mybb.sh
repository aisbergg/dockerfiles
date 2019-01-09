#!/bin/bash

# exit on errors
set -e

print_info "Configuring MyBB"

# removing all files before installing
if [[ `bool "$CLEAN_INSTALLATION" false` == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/mybb/*
    shopt -u dotglob
fi

# if MyBB is not yet installed, copy it into web root
if [ ! -f '/var/www/mybb/inc/config.php' ]; then
    print_info "No previous MyBB installation found, creating a new one"
    if ! is_dir_empty /var/www/mybb; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install MyBB!"
        exit 1
    fi

    cd /tmp
    unzip -qq -d . /usr/local/src/mybb.zip Upload/*
    shopt -s dotglob
    mv Upload/* /var/www/mybb
    rm -rf /tmp/*
    shopt -u dotglob

    chown -R www-data:www-data /var/www/mybb/
    echo "${MYBB_VERSION}" > /var/www/mybb/.version

# check if the installed version can be upgraded
elif [[ `bool "$AUTO_UPDATE"` == "True" ]]; then
    # information about upgrading mybb can be found here: http://docs.mybb.com/1.8/install/upgrade/
    if [ ! -f /var/www/mybb/.version ]; then
        print_error "Installation found, but unable to find '.version' file!"
        exit 1
    fi
    INSTALLED_VERSION="$(cat /var/www/mybb/.version)"
    # check if newer version is available to upgrade the current installation
    if [ "$INSTALLED_VERSION" != "$MYBB_VERSION" ]; then
        print_info "Updating MyBB installation from $INSTALLED_VERSION to $MYBB_VERSION"

        cd /tmp
        unzip -qq -d . /usr/local/src/mybb.zip Upload/*
        # set file owner and group to www-data for all new files
        chown -R www-data:www-data Upload

        shopt -s dotglob
        cp -af Upload/* /var/www/mybb
        rm -rf /tmp/*
        shopt -u dotglob

        echo "${MYBB_VERSION}" > /var/www/mybb/.version
    fi

    # set file owner to www-data but leave the group as it is
    chown -R www-data /var/www/mybb
    # confine access permissions for settings file
    chmod 660 /var/www/mybb/inc/config.php

    unset INSTALLED_VERSION
fi
