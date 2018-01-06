#!/bin/bash

# exit on errors
set -e

python2 /provision/helper/merge_json_files.py /var/lib/mattermost/config.json /usr/local/src/config.json
rm /usr/local/src/config.json

# unset variables
unset ATRESTENCRYPTKEY PUBLICLINKSALT INVITESALT PASSWORDRESETSALT

if [ -f /var/lib/mattermost/.need-upgrade ]; then
    printINFO "Upgrading Mattermost database..."
    pushd /opt/mattermost 1>/dev/null
    ./bin/platform -upgrade_db_30
    popd 1>/dev/null
    rm /var/lib/mattermost/.need-upgrade
fi

# set owner and permissions
chmod 640 /var/lib/mattermost/config.json
chown mattermost -R /var/lib/mattermost
