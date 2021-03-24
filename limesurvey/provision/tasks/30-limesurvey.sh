#!/bin/bash
set -eo pipefail

print_info "Configuring Lime Survey"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "True" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# if Lime Survey is not yet installed, copy it into web root
if [[ ! -f /container/www/admin/admin.php || -f /container/www/.installation-in-progess ]]; then
    print_info "No previous Lime Survey installation found, creating a new one"
    if ! is_dir_empty /container/www || [[ -f /container/www/.installation-in-progess ]]; then
        print_error "Install dir is not empty! Make sure the target dir is empty before trying to install Lime Survey!"
        exit 1
    fi

    pushd /container/www >/dev/null
    # create lockfile
    touch .installation-in-progess

    tar xzf /usr/local/src/limesurvey.tar.gz --strip-components=1
    shopt -s dotglob
    chgrp 0 -R ./*
    chmod g+rwX,o-rwx -R ./*
    shopt -u dotglob

    rm .installation-in-progess
    popd >/dev/null

elif [[ $(bool "$LIMESURVEY_AUTO_UPDATE" "true") == "true" || -f /container/www/.update-in-progess ]]; then
    INSTALLED_VERSION=$(php -r '$config = include "/container/www/application/config/version.php"; echo $config["versionnumber"];')
    # check if newer version is available to upgrade the current installation
    if version_greater "${LIMESURVEY_VERSION}" "$INSTALLED_VERSION" || [[ -f /container/www/.update-in-progess ]]; then
        print_info "Updating Lime Survey ($INSTALLED_VERSION --> ${LIMESURVEY_VERSION})"

        pushd /container/www >/dev/null
        # create lockfile
        touch .update-in-progess

        tempdir="$(mktemp -d)"
        tar xzf /usr/local/src/limesurvey.tar.gz -C "$tempdir" --strip-components=1
        chgrp 0 -R "$tempdir"
        chmod g+rwX,o-rwx -R "$tempdir"

        rsync -rlD --delete \
            --exclude /application/config/config.php \
            --exclude /application/config/security.php \
            --exclude /upload/ \
            --exclude /themes/ \
            --exclude /plugins/ \
            --exclude /.update-in-progess \
            "$tempdir/" ./

        for dir in plugins themes; do
            rsync -rlD --include "/$dir/" --exclude '/*' "$tempdir/" ./
        done
        shopt -s dotglob
        chgrp 0 -R ./*  || true
        chmod g+rwX,o-rwx -R ./*  || true
        shopt -u dotglob

        rm -rf "$tempdir" .update-in-progess
        popd >/dev/null
    fi
fi
