#!/bin/bash

# exit on errors
set -e

print_info "Configuring Nginx"

if [[ `standardise_bool "$NGINX_TLS_TERMINATED" True` == False ]]; then
    if [[ ! -f "/etc/ssl/private/dhparam.pem" ]]; then
        # create Diffie-Hellman parameter for forward secrecy
        NGINX_DH_SIZE=${NGINX_DH_SIZE:-512}
        print_info "Generating ${NGINX_DH_SIZE}bit Diffie-Hellman-Parameter (May take a long time)..."
        openssl dhparam -out /etc/ssl/private/dhparam.pem "$NGINX_DH_SIZE" > /dev/null
    fi

    # if NGINX_TLS_CERT and NGINX_TLS_KEY are not specified set default value
    export NGINX_TLS_CERT=${NGINX_TLS_CERT:-"/etc/ssl/private/cert.pem"}
    export NGINX_TLS_KEY=${NGINX_TLS_KEY:-"/etc/ssl/private/key.pem"}

    # TLS certificate and key
    if [[ ! -f "$NGINX_TLS_CERT" && ! -f "$NGINX_TLS_KEY" ]]; then
        print_info "Generating TLS-Key and TLS-Certificate..."
        openssl req -x509 -newkey rsa:4096 \
        -subj "/C=/ST=/L=/O=/CN=localhost" \
        -keyout "$NGINX_TLS_KEY" \
        -out "$NGINX_TLS_CERT" \
        -days 365 -nodes -sha256 > /dev/null
    elif [[ -f "$NGINX_TLS_CERT" && ! -f "$NGINX_TLS_KEY" ]]; then
        print_error "TLS certificate given but no key found!"
        exit 1
    elif [[ ! -f "$NGINX_TLS_CERT" && -f "$NGINX_TLS_KEY" ]]; then
        print_error "TLS key given but no certificate found!"
        exit 1
    else
        print_info "Using existing TLS key and certificate"
    fi
fi

# temporary path to store large client bodies
mkdir -p /var/nginx/client_body_temp
chown www-data:www-data /var/nginx/client_body_temp
chmod 0750 /var/nginx/client_body_temp
