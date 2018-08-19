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
fi

# warn about lax permissions of the settings file
if [[ -f /container/www/application/config/database.php && "$(stat -c '%a' /container/www/application/config/database.php | cut -c 3)" -ge 4 ]]; then
    print_warning "ATTENTION: The settings file 'application/config/database.php' should not be world readable. Use 'chmod' to change its permissions."
fi

# to upgrade the installation checkout: http://documentation.concrete5.org/developers/installation/upgrading-concrete5
