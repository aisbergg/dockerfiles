#!/bin/bash
set -eo pipefail

if [[ -f /container/www/.update-in-progess-phase2 ]]; then
    # call upgrade routine
    pushd /container/www >/dev/null
    php occ upgrade --no-interaction
    php occ app:update --all
    php occ db:add-missing-indices
    php occ maintenance:repair

    php occ app:list | sed -n -n "/Disabled:/,//p" > .apps-after
    disabled_apps="$(diff -u .apps-before .apps-after | tail -n +5 | grep '+' | awk '{print $3}' | paste -sd ' ' - )" || true
    if [[ -n "$disabled_apps" ]]; then
        print_info "The following apps have been disabled: $disabled_apps"
    fi
    unset disabled_apps

    # remove upgrade indicator if upgrade succeeded
    rm ./{.update-in-progess-phase2,.apps-before,.apps-after}
    popd >/dev/null
fi
