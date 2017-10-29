#!/bin/bash

# exit on errors
set -e

print_info "Configuring phpList"

# if phpList is not yet installed, copy it into web root
if [ ! -f '/var/www/phplist/index.php' ]
then
    print_info "No previous phpList installation found, creating a new one"
    if ! is_dir_empty /var/www/phplist; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new phpList!"
        exit 1
    fi

    cd /tmp
    tar xf /usr/local/src/phplist.tgz
    shopt -s dotglob
    mv phplist-${PHPLIST_VERSION}/public_html/lists/* /var/www/phplist/
    shopt -u dotglob
    mkdir /var/www/phplist/uploadimages
    # remove phplist.org rssfeeds (those slow down the page loading)
    ( cd /var/www/phplist/admin && patch -p0 < /provision/templates/var/www/phplist/admin/no-newsfeed.patch 1>/dev/null )

    unzip -qq -d /var/www/phplist/admin/plugins/CKEditorPlugin/ /usr/local/src/ckeditor.zip

    # cleanup
    rm -rf /tmp/*

    # set the right owner and group of the webroot
    chown -R www-data:www-data /var/www/phplist/
    echo "INSTALLED_PHPLIST_VERSION=${PHPLIST_VERSION}" > /var/www/phplist/.version
    echo "INSTALLED_CKEDITOR_VERSION=${CKEDITOR_VERSION}" >> /var/www/phplist/.version

# check if the installed version can be upgraded
elif [[ `standardise_bool "$AUTO_UPDATE"` == "True" ]]; then
    # information about upgrading phplist can be found here: https://www.phplist.org/download-phplist/
    if [ ! -f /var/www/phplist/.version ]; then
        print_error "Installation found, but unable to find '.version' file!"
        exit 1
    fi
    source /var/www/phplist/.version
    # check if newer version is available to upgrade the current installation
    if [ "$INSTALLED_PHPLIST_VERSION" != "$PHPLIST_VERSION" ]; then
        print_info "Upgrading phpList installation from $INSTALLED_PHPLIST_VERSION to $PHPLIST_VERSION"
        # extract files of the new phplist
        cd /tmp
        tar xf /usr/local/src/phplist.tgz
        # set file owner and group to www-data for all new files
        chown -R www-data:www-data phplist-${PHPLIST_VERSION}

        # copy new files into the current installation
        rm phplist-${PHPLIST_VERSION}/public_html/lists/config/config.php
        shopt -s dotglob
        # overwrite with new files
        cp -af phplist-${PHPLIST_VERSION}/public_html/lists/* /var/www/phplist/
        shopt -u dotglob
        # remove phplist.org rssfeeds (those slow down the page loading)
        ( cd /var/www/phplist/admin && patch -p0 < /provision/templates/var/www/phplist/admin/no-newsfeed.patch 1>/dev/null )

        # cleanup
        rm -rf /tmp/*

        print_info "IMPORTANT: Login to the phpList admin pages and click the “upgrade” link"
        print_info "IMPORTANT: Just to be sure, use the “Verify database structure” page to check that your database structure is correct"
    fi
    if [ "$INSTALLED_CKEDITOR_VERSION" != "$CKEDITOR_VERSION" ]; then
        print_info "Upgrading CKEditor from $INSTALLED_CKEDITOR_VERSION to $CKEDITOR_VERSION"
        unzip -qqo -d /var/www/phplist/admin/plugins/CKEditorPlugin/ /usr/local/src/ckeditor.zip
        chown -R www-data:www-data /var/www/phplist/admin/plugins/CKEditorPlugin
    fi

    echo "INSTALLED_PHPLIST_VERSION=${PHPLIST_VERSION}" > /var/www/phplist/.version
    echo "INSTALLED_CKEDITOR_VERSION=${CKEDITOR_VERSION}" >> /var/www/phplist/.version
fi
