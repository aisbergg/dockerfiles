#!/bin/bash
set -eo pipefail

if [[ -n "$MUMBLE_SUPERUSER_PASSWORD" ]]; then
    # set SuperUser password
    /usr/bin/murmurd -ini /container/mumble-server/mumble-server.ini -supw "$MUMBLE_SUPERUSER_PASSWORD"
fi
