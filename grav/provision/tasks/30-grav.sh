#!/bin/bash
set -e

print_info "Configuring Grav"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# if Grav is not yet installed, copy it into web root
if [[ ! -f "/container/www/bin/grav" ]]; then
    if ! is_dir_empty /container/www; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Grav!"
        exit 1
    fi
    print_info "Installing Grav, might take some time..."
    COMPOSER_CACHE_DIR=/tmp/composer-cache composer --no-interaction create-project getgrav/grav /container/www
    pushd /container/www >/dev/null
    php bin/gpm --no-interaction install admin
    popd >/dev/null
    rm -rf /tmp/composer-cache

elif [[ $(bool "$GRAV_AUTO_UPDATE" true) == "true" ]]; then
    pushd /container/www > /dev/null
    ( php bin/gpm selfupgrade -f || true )
    popd > /dev/null
fi
