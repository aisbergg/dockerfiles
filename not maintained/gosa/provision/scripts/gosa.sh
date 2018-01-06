#!/bin/bash

# exit on errors
set -e

printINFO "Configuring GOsa²"

if [[ -f /etc/gosa/gosa.conf ]]; then
    chown root:www-data /etc/gosa/gosa.conf
    chmod 640 /etc/gosa/gosa.conf
fi
