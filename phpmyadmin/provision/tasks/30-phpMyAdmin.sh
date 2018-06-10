#!/bin/bash

print_info "Configuring phpMyAdmin"

# create random string to be used as blowfish secret
export PHPMYADMIN_BLOWFISH_SECRET="$(create_random_string 64)"
