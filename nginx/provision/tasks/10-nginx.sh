#!/bin/bash
set -eo pipefail

print_info "Configuring Nginx"

export NGINX_TLS_CERT=${NGINX_TLS_CERT:-"/etc/ssl/private/cert.pem"}
export NGINX_TLS_KEY=${NGINX_TLS_KEY:-"/etc/ssl/private/key.pem"}
export NGINX_DHPARAM=${NGINX_DHPARAM:-"/etc/ssl/private/dhparam.pem"}
# !!! INSECURE, FOR TESTING ONLY !!!
# !!! IN PRODUCTION USE 4096 !!!
export NGINX_DHPARAM_SIZE=${NGINX_DHPARAM_SIZE:-"512"}

if [[ $(bool "$NGINX_TLS_TERMINATED" true) == false ]]; then
    # TLS certificate and key
    if [[ ! -f "$NGINX_TLS_CERT" && ! -f "$NGINX_TLS_KEY" ]]; then
        print_info "Generating TLS-Key and TLS-Certificate..."
        openssl req -x509 -newkey rsa:4096 \
        -subj "/C=DE/ST=Devtown/L=Devland/O=Developer/CN=localhost" \
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

    # Diffie-Hellman parameter for forward secrecy
    if [[ ! -f "$NGINX_DHPARAM" ]]; then
        print_info "Generating ${NGINX_DHPARAM_SIZE}bit Diffie-Hellman-Parameter (May take a long time)..."
        openssl dhparam -out "$NGINX_DHPARAM" "$NGINX_DHPARAM_SIZE"
    fi
fi
