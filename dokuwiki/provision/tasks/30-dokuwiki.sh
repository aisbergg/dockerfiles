#!/bin/bash
set -eo pipefail

print_info "Configuring DokuWiki"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == true ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# install DokuWiki
if [[ ! -f /container/www/doku.php || -f /container/www/.installation-in-progess ]]; then
    print_info "No previous Dokuwiki installation found, creating a new one"
    if ! is_dir_empty /container/www || [[ -f /container/www/.installation-in-progess ]]; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install DokuWiki!"
        exit 1
    fi

    pushd /container/www >/dev/null
    # create lockfile
    touch .installation-in-progess

    # extract files
    tar xzf /usr/local/src/dokuwiki.tar.gz --strip-components=1
    shopt -s dotglob
    chmod g+rwX,o-rwx -R ./*
    chgrp root -R ./*
    shopt -u dotglob

    rm .installation-in-progess
    popd >/dev/null

# update DokuWiki without destroying the userdata
elif [[ $(bool "$DOKUWIKI_AUTO_UPDATE" "true") == "true" || -f /container/www/.update-in-progess ]]; then
    # information about upgrading dokuwiki can be found here: https://www.dokuwiki.org/install:upgrade
    INSTALLED_VERSION="$(head -n 1 /container/www/VERSION | grep -o '^[^\ ]*')"
    if version_greater "$DOKUWIKI_VERSION" "$INSTALLED_VERSION" || [[ -f /container/www/.update-in-progess ]]; then
        print_info "Updating DokuWiki ($INSTALLED_VERSION --> $DOKUWIKI_VERSION)"

        pushd /container/www >/dev/null
        # create lockfile
        touch .update-in-progess

        tar xzf /usr/local/src/dokuwiki.tar.gz --strip-components=1
        grep -Ev '^($|#)' data/deleted.files | xargs -n 1 rm -vrf

        rm .update-in-progess
        popd >/dev/null
    fi

    unset INSTALLED_VERSION
fi

# will activate a rule in nginx/conf.d/dokuwiki.conf
if [[ -f /container/www/conf/users.auth.php ]]; then
    export DOKUWIKI_IS_INSTALLED="true"
else
    export DOKUWIKI_IS_INSTALLED="false"
fi
