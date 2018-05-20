#!/bin/bash
set -e

print_info "Configuring Etherpad"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /data/etherpad/*
    shopt -u dotglob
fi

# check if an valid Etherpad installation is present, else create a new one
if [[ ! -f '/data/etherpad/src/package.json' ]]; then
    print_info "No previous Etherpad installation found, creating a new one"
    if ! is_dir_empty /data/etherpad; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Etherpad!"
        exit 1
    fi

    tar xfz /usr/local/src/etherpad.tar.gz -C /data/etherpad --strip-components=1
    shopt -s dotglob
    chmod g+rwX,o-rwx -R /data/etherpad/* &&\
    chgrp root -R /data/etherpad/*
    shopt -u dotglob

    pushd /data/etherpad >/dev/null

    # make sure dependencies are met
    bin/installDeps.sh

    print_info "Install etherpad plugins"
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
        ep_font_color \
        ep_subscript_and_superscript \
        ep_align

    popd >/dev/null

# check if the installed version can be upgraded
elif [[ $(bool "$AUTO_UPDATE" "true") == "true" ]]; then
    INSTALLED_VERSION="$(grep '"version"' /data/etherpad/src/package.json | grep -Eo '[1-9\.]+')"

    # check if newer version is available to upgrade the current installation
    if version_greater "$ETHERPAD_VERSION" "$INSTALLED_VERSION" ; then
        print_info "Upgrading Etherpad ($INSTALLED_VERSION --> $ETHERPAD_VERSION)"

        tempdir="$(mktemp -d)"
        tar xfz /usr/local/src/etherpad.tar.gz -C "$tempdir" --strip-components=1

        rsync -rlD --delete \
            --exclude /node_modules/ \
            --exclude /var/ \
            --exclude /favicon.ico \
            --exclude /settings.json \
            "$tempdir/" /data/etherpad/

        rm -rf "$tempdir"
    fi

    unset INSTALLED_VERSION
fi
