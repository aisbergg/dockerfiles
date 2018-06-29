#!/bin/bash
set -eo pipefail

print_info "Configuring HAProxy"

export HAPROXY_TLS_DHPARAM=${HAPROXY_TLS_DHPARAM:-"/container/tls/dhparam.pem"}
export HAPROXY_TLS_DHPARAM_SIZE=${HAPROXY_TLS_DHPARAM_SIZE:-"2048"}
export INIT=tini
export INIT_ARGS=(/usr/bin/run-haproxy.py "${HAPROXY_CONFIG_FILE:-/container/cfg/haproxy.cfg}")

if (( $(find /container/tls/certs -iname '*.pem' | wc -l) == 0 )); then
    print_info "Generating TLS-Key and TLS-Certificate..."
    tempdir="$(mktemp -d)"
    openssl req -x509 -newkey rsa:4096 \
    -subj "/CN=$HOSTNAME" \
    -keyout "$tempdir/key" \
    -out "$tempdir/cert" \
    -days 365 -nodes -sha256 > /dev/null
    cat $tempdir/key $tempdir/cert > /container/tls/certs/${HOSTNAME}.pem
    chmod o-rwx /container/tls/certs/${HOSTNAME}.pem
    rm -r $tempdir
fi

# Diffie-Hellman parameter for forward secrecy
if [[ ! -f "$HAPROXY_TLS_DHPARAM" ]]; then
    print_info "Generating ${HAPROXY_TLS_DHPARAM_SIZE} bit Diffie-Hellman-Parameter (May take a long time)..."
    openssl dhparam -out "$HAPROXY_TLS_DHPARAM" "$HAPROXY_TLS_DHPARAM_SIZE"
    chmod o-rwx "$HAPROXY_TLS_DHPARAM"
fi
