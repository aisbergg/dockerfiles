#!/bin/bash
set -e

print_info "Configuring Etherpad"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/etherpad/*
    shopt -u dotglob
fi

# check if an valid Etherpad installation is present, else create a new one
if [[ ! -f '/container/etherpad/src/package.json' ]]; then
    print_info "No previous Etherpad installation found, creating a new one"
    if ! is_dir_empty /container/etherpad; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install a new Etherpad!"
        exit 1
    fi

    tar xzf /usr/local/src/etherpad.tar.gz -C /container/etherpad --strip-components=1
    shopt -s dotglob
    chmod g+rwX,o-rwx -R /container/etherpad/* &&\
    chgrp root -R /container/etherpad/*
    shopt -u dotglob

    pushd /container/etherpad >/dev/null

    # make sure dependencies are met
    bin/installDeps.sh

    print_info "Install etherpad plugins"
    npm install \
        ep_headings2 \
        ep_adminpads \
        ep_historicalsearch \
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
    INSTALLED_VERSION="$(grep '"version"' /container/etherpad/src/package.json | grep -Eo '[1-9\.]+')"

    # check if newer version is available to upgrade the current installation
    if version_greater "$ETHERPAD_VERSION" "$INSTALLED_VERSION" ; then
        print_info "Upgrading Etherpad ($INSTALLED_VERSION --> $ETHERPAD_VERSION)"

        tempdir="$(mktemp -d)"
        tar xzf /usr/local/src/etherpad.tar.gz -C "$tempdir" --strip-components=1

        rsync -rlD --delete \
            --exclude /node_modules/ \
            --exclude /var/ \
            --exclude /favicon.ico \
            --exclude /settings.json \
            "$tempdir/" /container/etherpad/

        pushd /container/etherpad >/dev/null
        npm update || true
        popd >/dev/null

        rm -rf "$tempdir"
    fi

    unset INSTALLED_VERSION
fi
