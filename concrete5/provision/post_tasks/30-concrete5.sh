#!/bin/bash
set -e

if [[ -f /container/www/.need-to-install ]]; then
    CONCRETE5_DB_SERVER=${CONCRETE5_DB_SERVER:-"mysql"}
    CONCRETE5_DB_USERNAME=${CONCRETE5_DB_USERNAME:-"concrete5"}
    CONCRETE5_DB_PASSWORD=${CONCRETE5_DB_PASSWORD:-""}
    CONCRETE5_DB_NAME=${CONCRETE5_DB_NAME:-""}
    CONCRETE5_SITE_NAME=${CONCRETE5_SITE_NAME:-"Concrete5 Site"}
    CONCRETE5_STARTING_POINT=${CONCRETE5_STARTING_POINT:-"elemental_blank"}
    CONCRETE5_EMAIL=${CONCRETE5_EMAIL:-""}
    CONCRETE5_PASSWORD=${CONCRETE5_PASSWORD:-""}
    CONCRETE5_LOCALE=${CONCRETE5_LOCALE:-"en_US"}

    print_info "Wait a few seconds for the database to become available"
    sleep 10

    pushd /container/www >/dev/null
    php concrete/bin/concrete5 c5:install --db-server="$CONCRETE5_DB_SERVER" --db-username="$CONCRETE5_DB_USERNAME" --db-password="$CONCRETE5_DB_PASSWORD" --db-database="$CONCRETE5_DB_NAME" --site="$CONCRETE5_SITE_NAME" --starting-point="$CONCRETE5_STARTING_POINT" --admin-email="$CONCRETE5_EMAIL" --admin-password="$CONCRETE5_PASSWORD" --site-locale="$CONCRETE5_LOCALE"
    popd >/dev/null

    rm /container/www/.need-to-install
fi
