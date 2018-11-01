#!/bin/bash
set -e

print_info "Configuring Mumble-Server (Murmur)"

export MUMBLE_TLS_CERT=${MUMBLE_TLS_CERT:-"/container/tls/cert.pem"}
export MUMBLE_TLS_KEY=${MUMBLE_TLS_KEY:-"/container/tls/key.pem"}
export MUMBLE_TLS_DHPARAMS=${MUMBLE_TLS_DHPARAMS:-"/container/tls/dhparam.pem"}

# if no TLS certificate is specified, then generate a self-signed one
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
# if no Diffie-Hellman parameters file for forward secrecy is specified, then generate it
if [[ ! -f "$MUMBLE_TLS_DHPARAMS" ]]; then
    MUMBLE_TLS_DHSIZE=${MUMBLE_TLS_DHSIZE:-2048}
    print_info "Generating ${MUMBLE_TLS_DHSIZE} bit Diffie-Hellman-Parameter (May take a long time)..."
    openssl dhparam -out "$MUMBLE_TLS_DHPARAMS" $MUMBLE_TLS_DHSIZE > /dev/null
else
    print_info "Using existing dhparams file"
fi
