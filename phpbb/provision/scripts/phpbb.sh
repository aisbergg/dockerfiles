#!/bin/bash

# exit on errors
set -e

print_info "Configuring phpBB"

# removing all files before installing
if [[ `bool "$CLEAN_INSTALLATION" false` == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/phpbb/*
    shopt -u dotglob
fi

# if phpBB is not yet installed, copy it into web root
if [ ! -f '/var/www/phpbb/index.php' ]
then
    print_info "No previous phpBB installation found, creating a new one"
    if ! is_dir_empty /var/www/phpbb; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new phpBB!"
        exit 1
    fi

    cd /tmp
    unzip -qq -d . /usr/local/src/phpbb.zip phpBB3/*
    mv phpBB3/* /var/www/phpbb
    rm -rf /tmp/*
    chown -R www-data:www-data /var/www/phpbb/
    echo "${PHPBB_VERSION}" > /var/www/phpbb/.version

# check if the installed version can be upgraded
elif [[ `bool "$AUTO_UPDATE"` == "True" ]]; then
    # information about upgrading phpbb can be found here: https://www.siteground.com/tutorials/phpbb2/phpbb_upgrade.htm
    # or here: https://www.phpbb.com/support/docs/en/3.1/ug/upgradeguide/upgrade3/
    if [ ! -f /var/www/phpbb/.version ]; then
        print_error "Installation found, but unable to find '.version' file!"
        exit 1
    fi
    INSTALLED_VERSION="$(cat /var/www/phpbb/.version)"
    # check if newer version is available to upgrade the current installation
    if [ "$INSTALLED_VERSION" != "$PHPBB_VERSION" ]; then
        print_info "Upgrading phpBB installation from $INSTALLED_VERSION to $PHPBB_VERSION"
        # extract files of the new phpBB
        cd /tmp
        unzip -qq -d . /usr/local/src/phpbb.zip phpBB3/*
        # set file owner and group to www-data for all new files
        chown -R www-data:www-data phpBB3

        # copy new files into the current installation
        rm phpBB3/config.php
        shopt -s dotglob
        cp -af phpBB3/* /var/www/phpbb
        rm -rf /tmp/*
        shopt -u dotglob

        # perform database update
        php /var/www/phpbb/bin/phpbbcli.php db:migrate --safe-mode
        # remove install dir
        rm -r /var/www/phpbb/install

        # set file owner but leave the group as it is
        chown -R www-data /var/www/phpbb/
        # confine access permissions for settings file
        chmod 660 /var/www/phpbb/config.php

        echo "${PHPBB_VERSION}" > /var/www/phpbb/.version
    fi

    unset INSTALLED_VERSION
fi

export IMAGEMAGICK_SHARED_SECRET="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c40; echo "")"
