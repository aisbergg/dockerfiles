#!/bin/bash
set -e

print_info "Configuring Grav"

export NGINX_TLS_ONLY=`bool "$NGINX_TLS_ONLY" true`
export AUTO_UPDATE=`bool "$AUTO_UPDATE" true`

# removing all files before installing
if [[ `bool "$CLEAN_INSTALLATION" false` == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/grav/*
    shopt -u dotglob
fi

# if Grav is not yet installed, copy it into web root
if [ ! -f "/var/www/grav/bin/grav" ]; then
    if ! is_dir_empty /var/www/grav; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Grav!"
        exit 1
    fi
    print_info "Installing Grav, might take a few seconds"

    chown www-data:www-data /var/www/grav
    su -s /bin/sh www-data -c "COMPOSER_CACHE_DIR=/tmp/composer-cache composer --no-interaction --quiet create-project getgrav/grav /var/www/grav && cd /var/www/grav && php bin/gpm --no-interaction --quiet install admin"
    rm -rf /tmp/composer-cache

elif [[ "$AUTO_UPDATE" == "True" ]]; then
    pushd /var/www/grav > /dev/null
    set +e
    su -s /bin/sh www-data -c "php bin/gpm selfupgrade -f"
    set -e
    popd > /dev/null
fi
