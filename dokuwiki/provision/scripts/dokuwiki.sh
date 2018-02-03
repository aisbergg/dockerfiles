#!/bin/bash

# exit on errors
set -e

print_info "Configuring DokuWiki"

# removing all files before installing
if [[ `bool "$CLEAN_INSTALLATION" false` == true ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/dokuwiki/*
    shopt -u dotglob
fi

# if DokuWiki is not yet installed, copy it into web root
if [ ! -f '/var/www/dokuwiki/doku.php' ]; then
    print_info "No previous Dokuwiki installation found, creating a new one"
    if ! is_dir_empty /var/www/dokuwiki; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new DokuWiki!"
        exit 1
    fi

    # extract DokuWiki files
    tar -xzf /usr/local/src/dokuwiki.tgz -C /var/www/dokuwiki --strip-components=1

    # setting owner and group to 'www-data'
    chown -R www-data:www-data /var/www/dokuwiki

# check if the installed version can be upgraded
elif [[ `bool "$AUTO_UPDATE"` == "True" ]]; then
    # information about upgrading dokuwiki can be found here: https://www.dokuwiki.org/install:upgrade
    INSTALLED_VERSION="$(head -n 1 /var/www/dokuwiki/VERSION | grep -o '^[^\ ]*')"
    if [ "$INSTALLED_VERSION" != "$DOKUWIKI_VERSION" ]; then
        # upgrade installation without destroying the userdata
        print_info "Upgrading DokuWiki installation from $INSTALLED_VERSION to ${DOKUWIKI_VERSION}"
        cd /var/www/dokuwiki
        tar -xzf /usr/local/src/dokuwiki.tgz --strip-components=1
        grep -Ev '^($|#)' data/deleted.files | xargs -n 1 rm -vrf

        # set file owner to www-data but leave the group as it is
        chown -R www-data /var/www/dokuwiki
    fi

    unset INSTALLED_VERSION
fi
