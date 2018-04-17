#!/bin/bash

if [[ -n "$MUMBLE_SUPERUSER_PASSWORD" ]]; then
    # set SuperUser password
    /usr/bin/mumble -ini /var/lib/mumble-server/mumble-server.ini -supw "$MUMBLE_SUPERUSER_PASSWORD"
fi
