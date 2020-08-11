#!/bin/bash
set -eo pipefail

print_info "Configuring Mumble-Server (Murmur)"

export MUMBLE_SSL_CERT=${MUMBLE_SSL_CERT:-"/container/tls/cert.pem"}
export MUMBLE_SSL_KEY=${MUMBLE_SSL_KEY:-"/container/tls/key.pem"}
export MUMBLE_SSL_DHPARAMS=${MUMBLE_SSL_DHPARAMS:-"/container/tls/dhparam.pem"}

# if no TLS certificate is specified, then generate a self-signed one
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
