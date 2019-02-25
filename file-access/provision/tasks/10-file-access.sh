#!/bin/bash
set -eo pipefail

print_info "File-Access Container"

export INIT=supervisor

if [[ ! -f /container/ssh/ssh_host_ed25519_key || ! -f /container/ssh/ssh_host_rsa_key ]]; then
    print_info "Creating host keys"
    if [[ ! -f /container/ssh/ssh_host_ed25519_key ]]; then
        ssh-keygen -t ed25519 -f /container/ssh/ssh_host_ed25519_key -q -N ""
        chmod 600 /container/ssh/ssh_host_ed25519_key
    fi
    if [[ ! -f /container/ssh/ssh_host_rsa_key ]]; then
        ssh-keygen -t rsa -b 4096 -f /container/ssh/ssh_host_rsa_key -q -N ""
        chmod 600 /container/ssh/ssh_host_rsa_key
    fi
fi
