#!/bin/bash

# exit on errors
set -e

print_info "Configuring Concrete5"

# removing all files before installing
if [[ `standardise_bool "$CLEAN_INSTALLATION" False` == True ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/concrete5/*
    shopt -u dotglob
fi

# check if an valid Concrete5 installation is present, else create a new one
if [ ! -f /var/www/concrete5/concrete/config/concrete.php ]; then
    print_info "No previous Concrete5 installation found, creating a new one"
    if ! is_dir_empty /var/www/concrete5; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Concrete5!"
        exit 1
    fi

    cd /tmp
    unzip -qq -d . /usr/local/src/concrete5.zip
    shopt -s dotglob
    mv -f concrete5-*/* /var/www/concrete5/
    rm -rf /tmp/*
    shopt -u dotglob

    # set file owner and group
    chown -R www-data:www-data /var/www/concrete5/

else
    # set file owner to www-data but leave the group as it is
    chown -R www-data /var/www/concrete5/
    # confine access permissions for settings file
    chmod 640 /var/www/concrete5/application/config/database.php
fi
# to upgrade the installation checkout: http://documentation.concrete5.org/developers/installation/upgrading-concrete5
