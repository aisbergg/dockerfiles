#!/bin/bash
set -e

print_info "Configuring Gitea"

if [[ -z "$DOMAINNAMES" ]]; then
    print_error "DOMAINNAMES needs to be set"
    exit 1
fi

if [[ -f /container/gitea/app.ini ]]; then
    export GITEA_SECURITY_SECRET_KEY="$(sed -nr 's/^SECRET_KEY *= *(.*)/\1/p' /container/gitea/app.ini)"
    export GITEA_SERVER_LFS_JWT_SECRET="$(sed -nr 's/^LFS_JWT_SECRET *= *(.*)/\1/p' /container/gitea/app.ini)"
else
    # create new random strings to be used as secrets
    export GITEA_SECURITY_SECRET_KEY="$(create_random_string 64)"
    export GITEA_SERVER_LFS_JWT_SECRET="$(create_random_string 64)"
fi

# create openssh host keys if they do not exist
if [[ ! -f /container/gitea/ssh/ssh_host_ed25519_key || ! -f /container/gitea/ssh/ssh_host_rsa_key || ! -f /container/gitea/ssh/ssh_host_ecdsa_key ]]; then
    print_info "Creating host keys"
    mkdir -p /container/gitea/ssh
    # generate only rsa and ed25519 host key since the other ones won't be used
    if [[ ! -f /container/gitea/ssh/ssh_host_ed25519_key ]]; then
        ssh-keygen -t ed25519 -f /container/gitea/ssh/ssh_host_ed25519_key -q -N ""
        chmod 600 /container/gitea/ssh/ssh_host_ed25519_key
    fi
    if [[ ! -f /container/gitea/ssh/ssh_host_rsa_key ]]; then
        ssh-keygen -t rsa -b 4096 -f /container/gitea/ssh/ssh_host_rsa_key -q -N ""
        chmod 600 /container/gitea/ssh/ssh_host_rsa_key
    fi
    if [[ ! -f /container/gitea/ssh/ssh_host_ecdsa_key ]]; then
        ssh-keygen -t ecdsa -b 521 -f /container/gitea/ssh/ssh_host_ecdsa_key -q -N ""
        chmod 600 /container/gitea/ssh/ssh_host_ecdsa_key
    fi
fi
