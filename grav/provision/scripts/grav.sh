#!/bin/bash

# exit on errors
set -e

print_info "Configuring Grav"

export NGINX_TLS_ONLY=`standardise_bool "$NGINX_TLS_ONLY" True`
export AUTO_UPDATE=`standardise_bool "$AUTO_UPDATE" True`

# removing all files before installing
if [[ `standardise_bool "$CLEAN_INSTALLATION" False` == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/grav/*
    shopt -u dotglob
fi

# if Grav is not yet installed, copy it into web root
if [ ! -f "/var/www/grav/index.php" ]; then
    if ! is_dir_empty /var/www/grav; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Grav!"
        exit 1
    fi
    print_info "No previous Grav installation found, creating a new one"

    cd /tmp
    unzip -qq -d . /usr/local/src/grav.zip
    shopt -s dotglob
    mv -f grav-admin/* /var/www/grav/
    rm -rf /tmp/*
    shopt -u dotglob

    # set rightful owner
    chown -R www-data:www-data /var/www/grav

elif [[ "$AUTO_UPDATE" == "False" ]]; then
    pushd /var/www/grav > /dev/null
    su -s /bin/sh www-data -c "php bin/gpm selfupgrade -f"
    popd > /dev/null
fi
