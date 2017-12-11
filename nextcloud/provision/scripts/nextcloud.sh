#!/bin/bash

# exit on errors
set -e

print_info "Configuring Nextcloud"

if [[ -z DOMAINNAMES ]]; then
    print_error "You need to specify at least one domainname"
    exit 1
fi
export NGINX_TLS_ONLY=`standardise_bool "$NGINX_TLS_ONLY" True`

# removing all files before installing
if [[ `standardise_bool "$CLEAN_INSTALLATION" False` == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /var/www/nextcloud/*
    shopt -u dotglob
fi

# if Nextcloud is not yet installed, copy it into web root
if [ ! -f "/var/www/nextcloud/version.php" ]; then
    if ! is_dir_empty /var/www/nextcloud; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Nextcloud!"
        exit 1
    fi
    print_info "No previous Nextcloud installation found, creating a new one"

    # copy files
    tar xjf /usr/local/src/nextcloud.tar.bz2 -C /var/www/nextcloud --strip-components=1

    # create dirs
    mkdir -p /var/lib/nextcloud/skeleton /var/www/nextcloud/assets

    # set rightful owner
    chown -R www-data:www-data /var/www/nextcloud
    chown root:www-data /var/www/nextcloud
    chown -R www-data:www-data /var/lib/nextcloud

# check if the installed version can be upgraded
elif [[ `standardise_bool "$AUTO_UPDATE"` == "True" ]]; then
    INSTALLED_VERSION="$(cat /var/www/nextcloud/version.php | grep '$OC_VersionString' | grep -o "'\S*'" | grep -o "[^\']*")"
    if [ "$INSTALLED_VERSION" != "$NEXTCLOUD_VERSION" ]; then
        # upgrade installation without destroying the userdata
        print_info "Upgrading Nextcloud installation from $INSTALLED_VERSION to $NEXTCLOUD_VERSION"

        # extract new files
        tempdir="$(mktemp -d)"
        cd $tempdir
        tar xjf /usr/local/src/nextcloud.tar.bz2 --strip-components=1

        # set file owner and group to www-data for all new files
        chown -R www-data:www-data $tempdir

        # copy important files from current installation
        cp -af /var/www/nextcloud/config/* ./config/
        merge_dirs /var/www/nextcloud/apps ./apps
        if [ -d /var/www/nextcloud/themes ]; then
            merge_dirs /var/www/nextcloud/themes ./themes
        fi
        if [ -f /var/www/nextcloud/favicon.ico ]; then
            cp /var/www/nextcloud/favicon.ico ./favicon.ico
        fi
        if [ -f /var/www/nextcloud/.user.ini ]; then
            cp /var/www/nextcloud/.user.ini ./.user.ini
        fi

        # place everything back into /var/www/nextcloud
        shopt -s dotglob
        rm -r /var/www/nextcloud/*
        mv $tempdir/* /var/www/nextcloud/
        shopt -u dotglob
        mkdir -p /var/www/nextcloud/assets

        # set file owner but leave the group as it is
        chown -R www-data /var/www/nextcloud
        chown root /var/www/nextcloud
        chown -R www-data /var/lib/nextcloud

        touch /var/www/nextcloud/.needs-upgrade

        # cleanup
        rm -r $tempdir
    fi

    unset INSTALLED_VERSION
fi
