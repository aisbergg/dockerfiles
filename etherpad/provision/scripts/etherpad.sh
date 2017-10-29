#!/bin/bash

# exit on errors
set -e

print_info "Configuring Etherpad"

# create a user for etherpad server to run with
useradd --create-home --system --user-group etherpad

# removing all files before installing
if [[ `standardise_bool "$CLEAN_INSTALLATION" False` == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /opt/etherpad/*
    shopt -u dotglob
fi

# check if an valid Etherpad installation is present, else create a new one
if [ ! -f '/opt/etherpad/bin/run.sh' ]; then
    print_info "No previous Etherpad installation found, creating a new one"
    if ! is_dir_empty /opt/etherpad; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Etherpad!"
        exit 1
    fi

    cd /opt
    unzip -qq -d . /usr/local/src/etherpad.zip
    shopt -s dotglob
    mv -f etherpad-lite-${ETHERPAD_VERSION}/* etherpad/
    shopt -u dotglob
    rmdir etherpad-lite-${ETHERPAD_VERSION}
    chown etherpad:etherpad -R /opt/etherpad

    # make sure dependencies are met
    su -s /bin/sh etherpad -c "cd /opt/etherpad && \
        bin/installDeps.sh"

    print_info "Install etherpad plugins"
    cd etherpad
    su -s /bin/sh etherpad -c "
    cd /opt/etherpad && \
    npm install \
        ep_headings2 \
        ep_adminpads \
        ep_historicalsearch \
        ep_html_export_using_client_filters \
        ep_page_view \
        ep_previewimages \
        ep_authornames \
        ep_markdown \
        ep_table_of_contents \
        ep_copy_paste_images \
        ep_font_color \
        ep_subscript_and_superscript \
        ep_align"

    echo "${ETHERPAD_VERSION}" > .version

# check if the installed version can be upgraded
elif [[ `standardise_bool "$AUTO_UPDATE"` == "True" ]]; then
    if [ ! -f /opt/etherpad/.version ]; then
        print_error "Installation found, but unable to find '.version' file!"
        exit 1
    fi
    INSTALLED_VERSION="$(cat /opt/etherpad/.version)"
    # check if newer version is available to upgrade the current installation
    if [ "$INSTALLED_VERSION" != "${ETHERPAD_VERSION}" ]; then
        print_info "Upgrading Etherpad installation from $INSTALLED_VERSION to $ETHERPAD_VERSION"

        # extract files of the new Etherpad
        cd /opt
        unzip -qq -d . /usr/local/src/etherpad.zip

        current_installation=etherpad
        new_installation=etherpad-lite-${ETHERPAD_VERSION}

        # copy important dirs and files from current installation to the new one
        merge_dirs $current_installation/node_modules $new_installation/node_modules
        mv -f $current_installation/settings.json $new_installation
        merge_dirs $current_installation/var $new_installation/var
        if [ -f $current_installation/favicon.ico ]; then
            cp $current_installation/favicon.ico $new_installation/favicon.ico
        fi

        # replace current installation with new one
        shopt -s dotglob
        rm -rf $current_installation/*
        mv -f $new_installation/* $current_installation/
        rmdir $new_installation
        shopt -u dotglob

        echo "${ETHERPAD_VERSION}" > etherpad/.version

        unset current_installation
        unset new_installation
    fi

    unset INSTALLED_VERSION
fi
