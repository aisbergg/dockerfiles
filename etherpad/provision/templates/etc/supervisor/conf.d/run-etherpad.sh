#!/bin/bash
set -e

export NODE_ENV=production

cd /container/etherpad
bin/installDeps.sh $* || exit 1
exec node /container/etherpad/node_modules/ep_etherpad-lite/node/server.js $*
