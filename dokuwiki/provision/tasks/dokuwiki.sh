#!/bin/bash
set -e

print_info "Configuring DokuWiki"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == true ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /data/www/*
    shopt -u dotglob
fi

# if DokuWiki is not yet installed, copy it into web root
if [[ ! -f '/data/www/doku.php' ]]; then
    print_info "No previous Dokuwiki installation found, creating a new one"
    if ! is_dir_empty /data/www; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new DokuWiki!"
        exit 1
    fi

    # extract DokuWiki files
    tar xzf /usr/local/src/dokuwiki.tgz -C /data/www --strip-components=1
    shopt -s dotglob
    chmod g+rwX,o-rwx -R /data/www/* &&\
    chgrp root -R /data/www/*
    shopt -u dotglob

# check if the installed version can be upgraded
elif [[ $(bool "$DOKUWIKI_AUTO_UPDATE" "true") == "true" ]]; then
    # information about upgrading dokuwiki can be found here: https://www.dokuwiki.org/install:upgrade
    INSTALLED_VERSION="$(head -n 1 /data/www/VERSION | grep -o '^[^\ ]*')"
    if version_greater "$DOKUWIKI_VERSION" "$INSTALLED_VERSION" ; then
        # upgrade installation without destroying the userdata
        print_info "Upgrading DokuWiki installation from $INSTALLED_VERSION to ${DOKUWIKI_VERSION}"
        cd /data/www
        tar xzf /usr/local/src/dokuwiki.tgz --strip-components=1
        grep -Ev '^($|#)' data/deleted.files | xargs -n 1 rm -vrf
    fi

    unset INSTALLED_VERSION
fi

# will activate a rule in nginx/conf.d/dokuwiki.conf
if [[ -f /data/www/conf/users.auth.php ]]; then
    export DOKUWIKI_IS_INSTALLED="true"
else
    export DOKUWIKI_IS_INSTALLED="false"
fi
