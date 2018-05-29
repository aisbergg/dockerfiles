#!/bin/bash
set -e

if [[ -f /container/www/.needs-upgrade ]]; then
    # call upgrade routine
    cd /container/www
    php occ upgrade --no-app-disable

    # remove upgrade indicator if upgrade succeeded
    rm /container/www/.needs-upgrade
fi
