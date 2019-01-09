#!/bin/bash
set -e

print_info "Configuring Wordpress"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# if Wordpress is not yet installed, copy it into web root
if [[ ! -d /container/www/wp-content || -f /container/www/.installation-in-progess ]]; then
    print_info "No previous Wordpress installation found, creating a new one"
    if ! is_dir_empty /container/www || [[ -f /container/www/.installation-in-progess ]]; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install Wordpress!"
        exit 1
    fi

    pushd /container/www >/dev/null
    # create lockfile
    touch .installation-in-progess

    tar xzf /usr/local/src/wordpress.tar.gz --strip-components=1
    shopt -s dotglob
    chmod g+rwX,o-rwx -R ./* &&\
    chgrp root -R ./*
    shopt -u dotglob

    rm .installation-in-progess
    popd >/dev/null

    # information about upgrading wordpress can be found here: https://codex.wordpress.org/Updating_WordPress
fi

# try to remove permissions for 'other'
chmod o-rwx /container/www/wp-config.php || true

# warn about lax permissions of the settings file
if [[ -f /container/www/wp-config.php && "$(stat -c '%a' /container/www/wp-config.php | cut -c 3)" -ge 4 ]]; then
    print_warning "ATTENTION: The settings file 'wp-config.php' should not be world readable. Use 'chmod' to change its permissions."
fi

export IMAGEMAGICK_SHARED_SECRET="$(create_random_string 64)"
