#!/bin/bash
set -e

if [[ -f /var/www/nextcloud/.needs-upgrade ]]; then
    # call upgrade routine
    cd /data/www
    php occ upgrade --no-app-disable

    # remove upgrade indicator if upgrade succeeded
    rm /var/www/nextcloud/.needs-upgrade
fi
