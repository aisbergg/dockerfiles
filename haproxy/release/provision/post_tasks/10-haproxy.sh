#!/bin/bash
set -e

cat /usr/local/src/haproxy.cfg.template.part1 /usr/local/src/haproxy.cfg.template.part2 > /container/cfg/haproxy.cfg.template

if [[ ! -f /container/cfg/haproxy.cfg ]]; then
    cp /usr/local/src/empty-haproxy.cfg /container/cfg/haproxy.cfg
fi
