#!/bin/bash

# exit on errors
set -e

print_info "Configuring MediaWiki"

# removing all files before installing
if [[ `standardise_bool "$CLEAN_INSTALLATION" False` == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/mediawiki/*
    shopt -u dotglob
fi

# if MediaWiki is not yet installed, copy it into web root
if [ ! -f '/var/www/mediawiki/LocalSettings.php' ]; then
    print_info "No previous MediaWiki installation found, creating a new one"
    if ! is_dir_empty /var/www/mediawiki; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new MediaWiki!"
        exit 1
    fi
    tar xfz /usr/local/src/mediawiki.tar.gz -C /var/www/mediawiki --strip-components=1
    chown -R www-data:www-data /var/www/mediawiki
    echo "${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" > /var/www/mediawiki/.version
    # temporary disable a nginx rule until the wiki is properly installed
    export MEDIAWIKI_IS_INSTALLED="False"

# check if the installed version can be upgraded
elif [[ `standardise_bool "$AUTO_UPDATE"` == "True" ]]; then
    # information about upgrading MediaWiki can be found here: https://www.mediawiki.org/wiki/Manual:Upgrading
    INSTALLED_VERSION="$(cat /var/www/mediawiki/.version)"
    # check if newer version is available to upgrade the current installation
    if [ "$INSTALLED_VERSION" != "${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" ]; then
        print_info "Upgrading MediaWiki installation from $INSTALLED_VERSION to ${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}"

        # extract files of the new MediaWiki
        cd /var/www
        tar xfz /usr/local/src/mediawiki.tar.gz

        current_installation=mediawiki
        new_installation=mediawiki-${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}

        # set file owner and group to www-data for all new files
        chown -R www-data:www-data $new_installation

        # copy important dirs and files from current installation to the new one
        merge_dirs $current_installation/images $new_installation/images
        if [ -d mediawiki/uploads ]; then
            merge_dirs $current_installation/uploads $new_installation/uploads
        fi
        merge_dirs $current_installation/skins $new_installation/skins
        merge_dirs $current_installation/extensions $new_installation/extensions
        cp -fa $current_installation/LocalSettings.php $new_installation/LocalSettings.php
        if [ -f $current_installation/favicon.ico ]; then
            cp -a $current_installation/favicon.ico $new_installation/favicon.ico
        fi

        # replace current installation with new one
        shopt -s dotglob
        rm -rf $current_installation/*
        mv $new_installation/* $current_installation
        rmdir $new_installation
        shopt -u dotglob

        # set file owner to www-data but leave the group as it is
        chown -R www-data mediawiki

        echo "${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" > /var/www/mediawiki/.version
        echo "Keep until update is finished" > /var/www/mediawiki/.needs-update

        unset current_installation
        unset new_installation
    fi

    if [ -f /var/www/mediawiki/.needs-update ]; then
        # call MediaWiki update routine
        cd /var/www/mediawiki/maintenance/
        php update.php
        # remove update indicator if update succeeded
        rm /var/www/mediawiki/.needs-update
    fi

    # confine access permissions for settings file
    chmod 660 /var/www/mediawiki/LocalSettings.php

    # will activate a rule in nginx/conf.d/mediawiki.conf
    export MEDIAWIKI_IS_INSTALLED="True"

    unset INSTALLED_VERSION
fi

export IMAGEMAGICK_SHARED_SECRET="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c40; echo "")"
