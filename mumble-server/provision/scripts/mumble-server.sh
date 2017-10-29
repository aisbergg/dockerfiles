#!/bin/bash

# exit on errors
set -e

print_info "Configuring Mumble-Server (Murmur)"

# if no TLS certificate is specified, then generate a self-signed one
if [ -z "$MUMBLE_SSL_CERT" ]; then
    mkdir -p /var/lib/mumble-server/ssl
    export MUMBLE_SSL_CERT="/var/lib/mumble-server/ssl/cert.pem"
    export MUMBLE_SSL_KEY="/var/lib/mumble-server/ssl/key.pem"
    # TLS certificate and key
    if [[ ! -f "$MUMBLE_SSL_CERT" && ! -f "$MUMBLE_SSL_KEY" ]]; then
        print_info "Generating TLS-Key and TLS-Certificate..."
        openssl req -x509 -newkey rsa:4096 \
        -subj "/C=/ST=/L=/O=/CN=Murmur" \
        -keyout "$MUMBLE_SSL_KEY" \
        -out "$MUMBLE_SSL_CERT" \
        -days 3650 -nodes -sha256 > /dev/null
    else
        print_info "Using existing TLS key and certificate"
    fi
fi
# if no Diffie-Hellman parameters file for forward secrecy is specified, then generate it
if [ -z "$MUMBLE_SSL_DHPARAMS" ]; then
    mkdir -p /var/lib/mumble-server/ssl
    export MUMBLE_SSL_DHPARAMS="/var/lib/mumble-server/ssl/dhparam.pem"
    if [[ ! -f "$MUMBLE_SSL_DHPARAMS" ]]; then
        if [ -z "$MUMBLE_SSL_DHSIZE" ]; then
            MUMBLE_SSL_DHSIZE=2048
        fi
        print_info "Generating ${MUMBLE_SSL_DHSIZE} bit Diffie-Hellman-Parameter (May take a long time)..."
        openssl dhparam -out "$MUMBLE_SSL_DHPARAMS" $MUMBLE_SSL_DHSIZE > /dev/null
    else
        print_info "Using existing dhparams file"
    fi
fi

chown -R mumble-server /var/lib/mumble-server
chmod o-rwx /var/lib/mumble-server
