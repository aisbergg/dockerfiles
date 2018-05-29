#!/bin/bash
set -e

print_info "Configuring Gogs"

if [[ -z "$DOMAINNAMES" ]]; then
    print_error "DOMAINNAMES needs to be set"
    exit 1
fi

# create random string to be used as secret key
export SECRET_KEY="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%' | head -c40; echo "")"

# create openssh host keys if they do not exist
if [[ ! -f /container/gogs/data/ssh/ssh_host_ed25519_key || ! -f /container/gogs/data/ssh/ssh_host_rsa_key ]]; then
    print_info "Creating host keys"
    mkdir -p /container/gogs/data/ssh
    # generate only rsa and ed25519 host key since the other ones won't be used
    if [[ ! -f /container/gogs/data/ssh/ssh_host_ed25519_key ]]; then
        ssh-keygen -t ed25519 -f /container/gogs/data/ssh/ssh_host_ed25519_key -q -N ""
    fi
    if [[ ! -f /container/gogs/data/ssh/ssh_host_rsa_key ]]; then
        ssh-keygen -t rsa -b 4096 -f /container/gogs/data/ssh/ssh_host_rsa_key -q -N ""
    fi
fi
