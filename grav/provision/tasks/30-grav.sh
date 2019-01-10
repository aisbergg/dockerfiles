#!/bin/bash
set -eo pipefail

print_info "Configuring Grav"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# if Grav is not yet installed, copy it into web root
if [[ ! -f /container/www/bin/grav || -f /container/www/.installation-in-progess ]]; then
    print_info "Installing Grav, might take some time..."
    if ! is_dir_empty /container/www || [[ -f /container/www/.installation-in-progess ]]; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install Grav!"
        exit 1
    fi

    pushd /container/www >/dev/null
    # create lockfile
    touch .installation-in-progess

    COMPOSER_CACHE_DIR=/tmp/composer-cache composer --no-interaction create-project getgrav/grav ./
    php bin/gpm --no-interaction install admin

    rm -rf /tmp/composer-cache .installation-in-progess
    popd >/dev/null

elif [[ $(bool "$GRAV_AUTO_UPDATE" true) == "true" ]]; then
    print_info "Trying to update Grav"

    pushd /container/www > /dev/null
    php bin/gpm selfupgrade -f -y || true
    popd > /dev/null
fi
