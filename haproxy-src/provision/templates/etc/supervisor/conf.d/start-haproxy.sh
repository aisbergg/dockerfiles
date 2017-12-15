#!/bin/bash

if [[ -n "$(pidof haproxy)" ]]; then
    reload_haproxy=(-sf `pidof haproxy`)
fi

exec /usr/sbin/haproxy -p /var/run/haproxy.pid -f /etc/haproxy/haproxy.cfg ${reload_haproxy[@]}
