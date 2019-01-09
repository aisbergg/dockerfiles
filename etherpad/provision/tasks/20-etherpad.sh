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
if [[ ! -f '/container/etherpad/src/package.json' || -f /container/etherpad/.installation-in-progess ]]; then
    print_info "No previous Etherpad installation found, creating a new one"
    if ! is_dir_empty /container/etherpad || [[ -f /container/etherpad/.installation-in-progess ]]; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install Etherpad!"
        exit 1
    fi

    pushd /container/etherpad >/dev/null
    # create lockfile
    touch .installation-in-progess

    tar xzf /usr/local/src/etherpad.tar.gz --strip-components=1
    shopt -s dotglob
    chmod g+rwX,o-rwx -R ./* &&\
    chgrp root -R ./*
    shopt -u dotglob

    # make sure dependencies are met
    bin/installDeps.sh

    print_info "Install Etherpad plugins"
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

    rm .installation-in-progess
    popd >/dev/null

# check if the installed version can be upgraded
elif [[ $(bool "$ETHERPAD_AUTO_UPDATE" "true") == "true" || -f /container/etherpad/.update-in-progess ]]; then
    INSTALLED_VERSION="$(grep '"version"' /container/etherpad/src/package.json | grep -Eo '[0-9\.]+')"

    # check if newer version is available to upgrade the current installation
    if version_greater "$ETHERPAD_VERSION" "$INSTALLED_VERSION" || [[ -f /container/etherpad/.update-in-progess ]]; then
        print_info "Updating Etherpad ($INSTALLED_VERSION --> $ETHERPAD_VERSION)"
        pushd /container/etherpad >/dev/null
        # create lockfile
        touch .update-in-progess

        tempdir="$(mktemp -d)"
        tar xzf /usr/local/src/etherpad.tar.gz -C "$tempdir" --strip-components=1

        rsync -rlD --delete \
            --exclude /node_modules/ \
            --exclude /var/ \
            --exclude /favicon.ico \
            --exclude /settings.json \
            "$tempdir/" ./

        npm update || true

        rm -rf "$tempdir" .update-in-progess
        popd >/dev/null
    fi

    unset INSTALLED_VERSION
fi
