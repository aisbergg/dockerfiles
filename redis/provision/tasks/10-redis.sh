#!/bin/bash
set -e

print_info "Configuring Redis"

export INIT=tini
export INIT_ARGS=(/usr/bin/redis-server /etc/redis/redis.conf)
