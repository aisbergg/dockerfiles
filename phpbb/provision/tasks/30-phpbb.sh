#!/bin/bash
set -e

print_info "Configuring phpBB"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /data/www/*
    shopt -u dotglob
fi

# if phpBB is not yet installed, copy it into web root
if [[ ! -f '/data/www/index.php' ]]; then
    print_info "No previous phpBB installation found, creating a new one"
    if ! is_dir_empty /data/www; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new phpBB!"
        exit 1
    fi

    unzip_strip /usr/local/src/phpbb.zip /data/www
    shopt -s dotglob
    chmod g+rwX,o-rwx -R /data/www/* &&\
    chgrp root -R /data/www/*
    shopt -u dotglob

# check if the installed version can be upgraded
elif [[ $(bool "$AUTO_UPDATE" "true") == "true" ]]; then
    # information about upgrading phpbb can be found here: https://www.siteground.com/tutorials/phpbb2/phpbb_upgrade.htm
    # or here: https://www.phpbb.com/support/docs/en/3.2/ug/upgradeguide/

    INSTALLED_VERSION="$(grep 'PHPBB_VERSION' /data/www/includes/constants.php | grep -Eo '[1-9\.]+')"
    # check if newer version is available to upgrade the current installation
    if version_greater "$PHPBB_VERSION" "$INSTALLED_VERSION" ; then
        print_info "Upgrading phpBB ($INSTALLED_VERSION --> $PHPBB_VERSION)"

        tempdir="$(mktemp -d)"

        # extract files of the new phpBB
        unzip_strip /usr/local/src/phpbb.zip "$tempdir"
        chmod g+rwX,o-rwx -R "$tempdir"

        rsync -rlD --delete \
            --exclude /ext/ \
            --exclude /files/ \
            --exclude /images/ \
            --exclude /language/ \
            --exclude /logs/ \
            --exclude /store/ \
            --exclude /styles/ \
            --exclude /config.php \
            "$tempdir/" /data/www/

        for dir in ext language styles; do
            rsync -rlD --include "/$dir/" --exclude '/*' "$tempdir/"  /data/www/
        done

        # perform database update
        php /data/www/bin/phpbbcli.php db:migrate --safe-mode
        # remove install dir
        rm -r /data/www/install

        # cleanup
        rm -rf "$tempdir"
    fi

    unset INSTALLED_VERSION
fi

export IMAGEMAGICK_SHARED_SECRET="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c40; echo "")"
