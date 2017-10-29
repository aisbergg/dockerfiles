#!/bin/bash

set -e

cd /opt/etherpad
bin/installDeps.sh $* || exit 1
exec node /opt/etherpad/node_modules/ep_etherpad-lite/node/server.js $*
