#!/bin/bash
set -e

print_info "Configuring Wordpress"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/wordpress/*
    shopt -u dotglob
fi

# if Wordpress is not yet installed, copy it into web root
if [[ ! -d '/var/www/wordpress/wp-content' ]]; then
    print_info "No previous Wordpress installation found, creating a new one"
    if ! is_dir_empty /var/www/wordpress; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Wordpress!"
        exit 1
    fi

    tar xfz /usr/local/src/wordpress.tar.gz -C /var/www
else
    if [[ -f '/var/www/wordpress/wp-config.php' ]]; then
        chmod o-rwx /var/www/wordpress/wp-config.php
    fi
fi
# information about upgrading wordpress can be found here: https://codex.wordpress.org/Updating_WordPress

export IMAGEMAGICK_SHARED_SECRET="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c40; echo "")"
