#!/bin/bash
# exit on errors
set -e

print_info "Configuring Redis"
# set right ownership
chown -R redis:redis /var/lib/redis
