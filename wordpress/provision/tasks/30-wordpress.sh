#!/bin/bash
set -eo pipefail

print_info "Configuring Wordpress"

# removing all files before installing
if [[ $(bool "$CLEAN_INSTALLATION" false) == "true" ]]; then
    print_info "Removing all files in installation dir"
    shopt -s dotglob
    rm -rf /container/www/*
    shopt -u dotglob
fi

# if Wordpress is not yet installed, copy it into web root
if [[ ! -f /container/www/wp-load.php || -f /container/www/.installation-in-progess ]]; then
    print_info "Installing Wordpress"

    WORDPRESS_LOCALE="${WORDPRESS_LOCALE:-de_DE}"
    WORDPRESS_DB_PREFIX="${WORDPRESS_DB_PREFIX:-wp_}"
    WORDPRESS_TITLE="${WORDPRESS_TITLE:-"Wordpress in a Docker Container"}"

    if [[ -z "$WORDPRESS_DB_NAME" || -z "$WORDPRESS_DB_USER" || -z "$WORDPRESS_DB_PASS" || -z "$WORDPRESS_DB_HOST" ]]; then
        print_error "In order to install Wordpress you need to provide information about the database connection: WORDPRESS_DB_NAME, WORDPRESS_DB_USER, WORDPRESS_DB_PASS, WORDPRESS_DB_HOST"
        exit 1
    fi

    if [[ -z "$WORDPRESS_URL" ]]; then
        if [[ -z "$DOMAINNAMES" ]]; then
            print_error "In order to install Wordpress you need to provide a URL that : WORDPRESS_DB_NAME, WORDPRESS_DB_USER, WORDPRESS_DB_PASS, WORDPRESS_DB_HOST"
            exit 1
        fi
        WORDPRESS_URL="https://${DOMAINNAMES%%,*}"
    fi

    if [[ -z "$WORDPRESS_ADMIN_USER" || -z "$WORDPRESS_ADMIN_PASSWORD" || -z "$WORDPRESS_ADMIN_EMAIL" ]]; then
        print_error "In order to install Wordpress you need to provide information about the admin user: WORDPRESS_ADMIN_USER, WORDPRESS_ADMIN_PASSWORD, WORDPRESS_ADMIN_EMAIL"
        exit 1
    fi

    pushd /container/www >/dev/null
    # create lockfile
    touch .installation-in-progess

    # download Wordpress source
    wp-cli.phar core download --allow-root --no-color --locale="$WORDPRESS_LOCALE"
    # create configuration file
    wp-cli.phar config create \
        --allow-root --no-color \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASS" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --dbprefix="$WORDPRESS_DB_PREFIX" \
        --locale="$WORDPRESS_LOCALE" \
        --url="$WORDPRESS_URL"
    # create database tables
    wp-cli.phar core install \
        --allow-root --no-color \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email

    mkdir -p wp-content/{themes,plugins,users,uploads}

    shopt -s dotglob
    chmod g+rwX,o-rwx -R ./* &&\
    chgrp root -R ./*
    shopt -u dotglob

    rm .installation-in-progess
    popd >/dev/null

elif [[ $(bool "$WORDPRESS_AUTO_UPDATE" false) == "true" ]]; then
    print_info "Updating Wordpress"

    pushd /container/www >/dev/null
    wp-cli.phar core update --allow-root --no-color
    popd >/dev/null
fi

# try to remove permissions for 'other'
chmod o-rwx /container/www/wp-config.php || true

# warn about lax permissions of the settings file
if [[ -f /container/www/wp-config.php && "$(stat -c '%a' /container/www/wp-config.php | cut -c 3)" -ge 4 ]]; then
    print_warning "ATTENTION: The settings file 'wp-config.php' should not be world readable. Use 'chmod' to change its permissions."
fi
