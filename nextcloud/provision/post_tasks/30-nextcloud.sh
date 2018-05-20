#!/bin/bash
set -e

if [[ -f /data/www/.needs-upgrade ]]; then
    # call upgrade routine
    cd /data/www
    php occ upgrade --no-app-disable

    # remove upgrade indicator if upgrade succeeded
    rm /data/www/.needs-upgrade
fi
