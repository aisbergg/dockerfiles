#!/bin/bash
set -e

print_info "Configuring MediaWiki"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /data/www/*
    shopt -u dotglob
fi

# if MediaWiki is not yet installed, copy it into web root
if [[ ! -f '/data/www/LocalSettings.php' ]]; then
    print_info "No previous MediaWiki installation found, creating a new one"
    if ! is_dir_empty /data/www; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new MediaWiki!"
        exit 1
    fi
    tar xfz /usr/local/src/mediawiki.tar.gz -C /data/www --strip-components=1
    ( shopt -s dotglob && chmod g+rwX -R /data/www/* && shopt -u dotglob )
    echo "${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" > /data/www/.version
    # temporary disable a nginx rule until the wiki is properly installed
    export MEDIAWIKI_IS_INSTALLED="false"

# check if the installed version can be upgraded
elif [[ $(bool "$AUTO_UPDATE" true) == "true" ]]; then
    # information about upgrading MediaWiki can be found here: https://www.mediawiki.org/wiki/Manual:Upgrading
    INSTALLED_VERSION="$(cat /data/www/.version)"
    # check if newer version is available to upgrade the current installation
    if version_greater "${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" "$INSTALLED_VERSION" ; then
        print_info "Upgrading MediaWiki installation from $INSTALLED_VERSION to ${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}"

        tempdir="$(mktemp -d)"
        tar xfz /usr/local/src/mediawiki.tar.gz -C "$tempdir" --strip-components=1

        rsync -rlD --delete \
            --exclude /extensions/ \
            --exclude /favicon.ico \
            --exclude /images/ \
            --exclude /LocalSettings.php \
            --exclude /skins/ \
            --exclude /uploads/ \
            "$tempdir/" /data/www/

        for dir in extensions skins; do
            rsync -rlD --include "/$dir/" --exclude '/*' "$tempdir/"  /data/www/
        done

        rm -rf "$tempdir"

        echo "${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" > /data/www/.version
        echo "Keep until update is finished" > /data/www/.needs-update
    fi

    unset INSTALLED_VERSION
fi

if [[ -f /data/www/.needs-update ]]; then
    # call MediaWiki update routine
    cd /data/www/maintenance
    php update.php
    # remove update indicator if update succeeded
    rm /data/www/.needs-update
fi

# will activate a rule in nginx/conf.d/mediawiki.conf
export MEDIAWIKI_IS_INSTALLED=${MEDIAWIKI_IS_INSTALLED:-"true"}

# confine access permissions for settings file
if [[ -f /data/www/LocalSettings.php ]]; then
    chmod o-rwx /data/www/LocalSettings.php
fi

export IMAGEMAGICK_SHARED_SECRET="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c40; echo "")"
