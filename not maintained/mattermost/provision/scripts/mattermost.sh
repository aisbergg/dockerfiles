#!/bin/bash

# exit on errors
set -e

printINFO "Configuring Mattermost"

if [ ! -f /var/lib/mattermost/config.json ]; then
    export ATRESTENCRYPTKEY="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c32; echo "")"
    export PUBLICLINKSALT="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c32; echo "")"
    export INVITESALT="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c32; echo "")"
    export PASSWORDRESETSALT="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c32; echo "")"

    cp /opt/mattermost/config/config.json /var/lib/mattermost/config.json
    echo "$MATTERMOST_VERSION" > /var/lib/mattermost/.version
else
    INSTALLED_VERSION=`cat /var/lib/mattermost/.version`
    # check if newer version is available to upgrade the current installation
    if [[ "$(cat /var/lib/mattermost/.version)" != "$MATTERMOST_VERSION" ]]; then
        printINFO "Mark the instalation to be upgraded"

        echo "$MATTERMOST_VERSION" > /var/lib/mattermost/.version
        echo "Installation needs to be upgraded" > /var/lib/mattermost/.need-upgrade
    fi
    unset INSTALLED_VERSION
fi

ln -sf /var/lib/mattermost/config.json /opt/mattermost/config/config.json
