#!/bin/bash

# exit on errors
set -e

print_info "Configuring Wordpress"

# removing all files before installing
if [[ `standardise_bool "$CLEAN_INSTALLATION" False` == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/wordpress/*
    shopt -u dotglob
fi

# if Wordpress is not yet installed, copy it into web root
if [ ! -f '/var/www/wordpress/wp-config.php' ]; then
    print_info "No previous Wordpress installation found, creating a new one"
    if ! is_dir_empty /var/www/wordpress; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Wordpress!"
        exit 1
    fi

    tar xfz /usr/local/src/wordpress.tar.gz -C /var/www
    chown -R www-data:www-data /var/www/wordpress/
else
    # set file owner to www-data but leave the group as it is
    chown -R www-data /var/www/wordpress/
    # confine access permissions for settings file
    chmod 660 /var/www/wordpress/wp-config.php
fi
# information about upgrading wordpress can be found here: https://codex.wordpress.org/Updating_WordPress

export IMAGEMAGICK_SHARED_SECRET="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c40; echo "")"
