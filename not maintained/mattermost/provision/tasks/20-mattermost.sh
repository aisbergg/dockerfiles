#!/bin/bash
set -e

print_info "Configuring Mattermost"

if [ ! -f /var/lib/mattermost/config.json ]; then
    export PHPMYADMIN_BLOWFISH_SECRET="$(create_random_string 64)"
    export ATRESTENCRYPTKEY="$(create_random_string 32)"
    export PUBLICLINKSALT="$(create_random_string 32)"
    export INVITESALT="$(create_random_string 32)"
    export PASSWORDRESETSALT="$(create_random_string 32)"

    cp /opt/mattermost/config/config.json /var/lib/mattermost/config.json
    echo "$MATTERMOST_VERSION" > /var/lib/mattermost/.version
else
    INSTALLED_VERSION=$(cat /var/lib/mattermost/.version)
    # check if newer version is available to upgrade the current installation
    if [[ "$(cat /var/lib/mattermost/.version)" != "$MATTERMOST_VERSION" ]]; then
        print_info "Mark the instalation to be upgraded"

        echo "$MATTERMOST_VERSION" > /var/lib/mattermost/.version
        echo "Installation needs to be upgraded" > /var/lib/mattermost/.need-upgrade
    fi
    unset INSTALLED_VERSION
fi

ln -sf /var/lib/mattermost/config.json /opt/mattermost/config/config.json
