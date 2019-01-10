#!/bin/bash
set -eo pipefail

print_info "Configuring phpBB"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# if phpBB is not yet installed, copy it into web root
if [[ ! -f /container/www/index.php || -f /container/www/.installation-in-progess ]]; then
    print_info "No previous phpBB installation found, creating a new one"
    if ! is_dir_empty /container/www || [[ -f /container/www/.installation-in-progess ]]; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install phpBB!"
        exit 1
    fi

    pushd /container/www >/dev/null
    # create lockfile
    touch .installation-in-progess

    unzip_strip /usr/local/src/phpbb.zip ./
    shopt -s dotglob
    chmod g+rwX,o-rwx -R ./* &&\
    chgrp root -R ./*
    shopt -u dotglob

    rm .installation-in-progess
    popd >/dev/null

# check if the installed version can be upgraded
elif [[ $(bool "$PHPBB_AUTO_UPDATE" "true") == "true" || -f /container/www/.update-in-progess ]]; then
    # information about upgrading phpbb can be found here: https://www.siteground.com/tutorials/phpbb2/phpbb_upgrade.htm
    # or here: https://www.phpbb.com/support/docs/en/3.2/ug/upgradeguide/

    INSTALLED_VERSION="$(grep 'PHPBB_VERSION' /container/www/includes/constants.php | grep -Eo '[0-9\.]+')"
    # check if newer version is available to upgrade the current installation
    if version_greater "$PHPBB_VERSION" "$INSTALLED_VERSION" || [[ -f /container/www/.update-in-progess ]]; then
        print_info "Updating phpBB ($INSTALLED_VERSION --> $PHPBB_VERSION)"

        pushd /container/www >/dev/null
        # create lockfile
        touch .update-in-progess

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
            --exclude /.update-in-progess \
            --exclude /config.php \
            "$tempdir/" ./

        for dir in ext language styles; do
            rsync -rlD --include "/$dir/" --exclude '/*' "$tempdir/" ./
        done

        # perform database update
        php bin/phpbbcli.php db:migrate --safe-mode
        # remove install dir
        rm -r install

        # cleanup
        rm -rf "$tempdir" .update-in-progess
        popd >/dev/null
    fi

    unset INSTALLED_VERSION
fi

export IMAGEMAGICK_SHARED_SECRET="$(create_random_string 64)"
