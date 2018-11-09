#!/bin/bash
set -e

if [[ -f /container/www/.needs-upgrade ]]; then
    # call upgrade routine
    cd /container/www
    php occ upgrade --no-interaction

    php occ app:list | sed -n -n "/Disabled:/,//p" > .apps-after
    disabled_apps="$(diff -u .apps-before .apps-after | tail -n +5 | grep '+' | awk '{print $3}' | paste -sd ' ' - )" || true
    if [[ -n "$disabled_apps" ]]; then
        print_info "The following apps have been disabled: $disabled_apps"
    fi
    unset disabled_apps

    # remove upgrade indicator if upgrade succeeded
    rm /container/www/{.needs-upgrade,.apps-before,.apps-after}
fi
