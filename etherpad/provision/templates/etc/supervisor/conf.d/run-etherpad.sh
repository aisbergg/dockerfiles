#!/bin/bash
set -e

export NODE_ENV=production

cd /data/etherpad
bin/installDeps.sh $* || exit 1
exec node /data/etherpad/node_modules/ep_etherpad-lite/node/server.js $*
