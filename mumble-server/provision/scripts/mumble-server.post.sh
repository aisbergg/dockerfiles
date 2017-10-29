#!/bin/bash

if [ -n "$MUMBLE_SUPERUSER_PASSWORD" ]; then
    # set SuperUser password
    su -s /bin/sh -c "/usr/sbin/murmurd -ini /var/lib/mumble-server/mumble-server.ini -supw \"$MUMBLE_SUPERUSER_PASSWORD\"" mumble-server
fi
