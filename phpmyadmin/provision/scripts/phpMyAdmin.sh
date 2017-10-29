#!/bin/bash

print_info "Configuring phpMyAdmin"

# create random string to be used as blowfish secret
export BLOWFISH_SECRET="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%' | head -c40; echo "")"
