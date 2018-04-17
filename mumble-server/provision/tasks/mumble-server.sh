#!/bin/bash
set -e

print_info "Configuring Mumble-Server (Murmur)"

# if no TLS certificate is specified, then generate a self-signed one
if [[ -z "$MUMBLE_TLS_CERT" ]]; then
    mkdir -p /var/lib/mumble-server/ssl
    export MUMBLE_TLS_CERT="/var/lib/mumble-server/ssl/cert.pem"
    export MUMBLE_TLS_KEY="/var/lib/mumble-server/ssl/key.pem"
    # TLS certificate and key
    if [[ ! -f "$MUMBLE_TLS_CERT" && ! -f "$MUMBLE_TLS_KEY" ]]; then
        print_info "Generating TLS-Key and TLS-Certificate..."
        openssl req -x509 -newkey rsa:4096 \
        -subj "/C=/ST=/L=/O=/CN=Murmur" \
        -keyout "$MUMBLE_TLS_KEY" \
        -out "$MUMBLE_TLS_CERT" \
        -days 3650 -nodes -sha256 > /dev/null
    else
        print_info "Using existing TLS key and certificate"
    fi
fi
# if no Diffie-Hellman parameters file for forward secrecy is specified, then generate it
if [[ -z "$MUMBLE_TLS_DHPARAMS" ]]; then
    mkdir -p /var/lib/mumble-server/ssl
    export MUMBLE_TLS_DHPARAMS="/var/lib/mumble-server/ssl/dhparam.pem"
    if [[ ! -f "$MUMBLE_TLS_DHPARAMS" ]]; then
        if [[ -z "$MUMBLE_TLS_DHSIZE" ]]; then
            MUMBLE_TLS_DHSIZE=2048
        fi
        print_info "Generating ${MUMBLE_TLS_DHSIZE} bit Diffie-Hellman-Parameter (May take a long time)..."
        openssl dhparam -out "$MUMBLE_TLS_DHPARAMS" $MUMBLE_TLS_DHSIZE > /dev/null
    else
        print_info "Using existing dhparams file"
    fi
fi

chmod o-rwx /var/lib/mumble-server
