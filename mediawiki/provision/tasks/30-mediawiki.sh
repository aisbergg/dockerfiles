#!/bin/bash
set -eo pipefail

print_info "Configuring MediaWiki"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# if MediaWiki is not yet installed, copy it into web root
if [[ ! -f /container/www/LocalSettings.php || -f /container/www/.installation-in-progess ]]; then
    print_info "No previous MediaWiki installation found, creating a new one"
    if ! is_dir_empty /container/www || [[ -f /container/www/.installation-in-progess ]]; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install MediaWiki!"
        exit 1
    fi

    pushd /container/www >/dev/null
    # create lockfile
    touch .installation-in-progess

    tar xzf /usr/local/src/mediawiki.tar.gz --strip-components=1
    tar xzf /usr/local/src/mediawiki-extension-math.tar.gz -C ./extensions
    shopt -s dotglob
    chmod g+rwX,o-rwx -R ./* &&\
    chgrp root -R ./*
    shopt -u dotglob

    rm .installation-in-progess
    popd >/dev/null

    # temporary disable a nginx rule until the wiki is properly installed
    export MEDIAWIKI_IS_INSTALLED="false"

# check if the installed version can be upgraded
elif [[ $(bool "$MEDIAWIKI_AUTO_UPDATE" true) == "true" || -f /container/www/.update-in-progess ]]; then
    # information about upgrading MediaWiki can be found here: https://www.mediawiki.org/wiki/Manual:Upgrading
    INSTALLED_VERSION="$(grep 'wgVersion' /container/www/includes/DefaultSettings.php | grep -Eo '[0-9\.]+')"
    # check if newer version is available to upgrade the current installation
    if version_greater "${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR}" "$INSTALLED_VERSION" || [[ -f /container/www/.update-in-progess ]]; then
        print_info "Updating MediaWiki ($INSTALLED_VERSION --> ${MEDIAWIKI_MAJOR}.${MEDIAWIKI_MINOR})"

        pushd /container/www >/dev/null
        # create lockfile
        touch .update-in-progess

        tempdir="$(mktemp -d)"
        tar xzf /usr/local/src/mediawiki.tar.gz -C "$tempdir" --strip-components=1
        tar xzf /usr/local/src/mediawiki-extension-math.tar.gz -C "$tempdir/extensions"

        rsync -rlD --delete \
            --exclude /extensions/ \
            --exclude /images/ \
            --exclude /skins/ \
            --exclude /.update-in-progess \
            --exclude /composer.local.json \
            --exclude /favicon.ico \
            --exclude /LocalSettings.php \
            "$tempdir/" ./

        for dir in extensions skins; do
            rsync -rlD --include "/$dir/" --exclude '/*' "$tempdir/" ./
        done

        shopt -s dotglob
        chmod g+rwX,o-rwx -R ./ || true
        chgrp root -R ./ || true
        shopt -u dotglob

        # fix syntax of Alpines 'timeout' program, so that ImageMagick can be used
        sed -i -e 's?/usr/bin/timeout \$MW_WALL_CLOCK_LIMIT?/usr/bin/timeout -t \$MW_WALL_CLOCK_LIMIT?g' /includes/shell/limit.sh

        php maintenance/update.php
        composer update --no-dev

        rm -rf "$tempdir" .update-in-progess
        popd >/dev/null
    fi

    unset INSTALLED_VERSION
fi

# will activate a rule in nginx/conf.d/mediawiki.conf
export MEDIAWIKI_IS_INSTALLED=${MEDIAWIKI_IS_INSTALLED:-"true"}

# try to remove permissions for 'other'
chmod o-rwx /container/www/LocalSettings.php || true

# warn about lax permissions of the settings file
if [[ -f /container/www/LocalSettings.php && "$(stat -c '%a' /container/www/LocalSettings.php | cut -c 3)" -ge 4 ]]; then
    print_warning "ATTENTION: The settings file 'LocalSettings.php' should not be world readable. Use 'chmod' to change its permissions."
fi
