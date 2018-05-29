#!/bin/bash
set -e

print_info "Configuring Concrete5"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == true ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# check if an valid Concrete5 installation is present, else create a new one
if [[ ! -f /container/www/concrete/config/concrete.php ]]; then
    print_info "No previous Concrete5 installation found, creating a new one"
    if ! is_dir_empty /container/www; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Concrete5!"
        exit 1
    fi

    unzip_strip /usr/local/src/concrete5.zip /container/www/
    echo "Still need to install" > /container/www/.need-to-install

elif [[ -f /container/www/application/config/database.php ]]; then
    chmod o-rwx /container/www/application/config/database.php
fi

# to upgrade the installation checkout: http://documentation.concrete5.org/developers/installation/upgrading-concrete5
