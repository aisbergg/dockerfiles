#!/bin/bash

# exit on errors
set -e

# confine access permissions for settings file
chmod 640 /opt/etherpad/settings.json
chown etherpad -R /opt/etherpad
