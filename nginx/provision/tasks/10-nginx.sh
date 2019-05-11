#!/bin/bash
set -eo pipefail

print_info "Configuring Nginx"

export NGINX_REWRITE_HTTPS=$(bool "$NGINX_REWRITE_HTTPS" true)
export NGINX_TLS_TERMINATED=$(bool "$NGINX_TLS_TERMINATED" true)
export NGINX_TLS_CERT=${NGINX_TLS_CERT:-"/container/tls/cert.pem"}
export NGINX_TLS_KEY=${NGINX_TLS_KEY:-"/container/tls/key.pem"}
export NGINX_TLS_DHPARAM=${NGINX_TLS_DHPARAM:-"/container/tls/dhparam.pem"}
# !!! INSECURE, FOR TESTING ONLY !!!
# !!! IN PRODUCTION USE 4096 !!!
export NGINX_TLS_DHPARAM_SIZE=${NGINX_TLS_DHPARAM_SIZE:-"512"}

if [[ "$NGINX_TLS_TERMINATED" == false ]]; then
    # TLS certificate and key
    if [[ ! -f "$NGINX_TLS_CERT" && ! -f "$NGINX_TLS_KEY" ]]; then
        print_info "Generating TLS-Key and TLS-Certificate..."
        openssl req -x509 -newkey rsa:4096 \
        -subj "/C=/ST=/L=/O=/CN=$HOSTNAME" \
        -keyout "$NGINX_TLS_KEY" \
        -out "$NGINX_TLS_CERT" \
        -days 365 -nodes -sha256 > /dev/null
        chmod o-rwx "$NGINX_TLS_KEY" "$NGINX_TLS_CERT"
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
    if [[ ! -f "$NGINX_TLS_DHPARAM" ]]; then
        print_info "Generating ${NGINX_TLS_DHPARAM_SIZE}bit Diffie-Hellman-Parameter (May take a long time)..."
        openssl dhparam -out "$NGINX_TLS_DHPARAM" "$NGINX_TLS_DHPARAM_SIZE"
        chmod o-rwx "$NGINX_TLS_DHPARAM"
    fi
fi
