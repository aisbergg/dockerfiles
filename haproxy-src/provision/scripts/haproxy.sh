#!/bin/bash
# configure nginx webserver

# exit on errors
set -e

print_info "Configuring HAProxy"
chown -R haproxy:haproxy /etc/haproxy
