#!/bin/bash

# exit on errors
set -e

print_info "Configuring Gogs"

if [[ -z "$DOMAINNAMES" ]]; then
    print_error "DOMAINNAMES needs to be set"
    exit 1
fi

# create random string to be used as secret key
export SECRET_KEY="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%' | head -c40; echo "")"

# create openssh host keys if they do not exist
if [[ ! -f /var/lib/gogs/data/ssh/ssh_host_ed25519_key || ! -f /var/lib/gogs/data/ssh/ssh_host_rsa_key ]]; then
    print_info "Creating host keys"
    mkdir -p /var/lib/gogs/data/ssh
    # generate only rsa and ed25519 host key scince the other ones won't be used
    if [ ! -f /var/lib/gogs/data/ssh/ssh_host_ed25519_key ]; then
        ssh-keygen -t ed25519 -f /var/lib/gogs/data/ssh/ssh_host_ed25519_key -q -N ""
    fi
    if [ ! -f /var/lib/gogs/data/ssh/ssh_host_rsa_key ]; then
        ssh-keygen -t rsa -b 4096 -f /var/lib/gogs/data/ssh/ssh_host_rsa_key -q -N ""
    fi
fi

if [ ! -d /var/lib/gogs/data/.ssh ]; then
    mkdir -p /var/lib/gogs/data/.ssh
fi
ln -sf /var/lib/gogs/data/.ssh /home/git/.ssh
