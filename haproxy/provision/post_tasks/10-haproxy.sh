#!/bin/bash
set -e

if [[ ! -f "${HAPROXY_CONFIG_FILE:-/container/cfg/haproxy.cfg}" ]]; then
    cp /etc/haproxy/haproxy.cfg /container/cfg/haproxy.cfg
fi
