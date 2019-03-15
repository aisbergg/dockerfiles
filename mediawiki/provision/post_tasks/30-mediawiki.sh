#!/bin/bash
set -eo pipefail

# fix syntax of Alpines 'timeout' program, so that ImageMagick can be used
patch /container/www/includes/shell/limit.sh /tmp/limit.sh.patch &>/dev/null || true
rm /tmp/limit.sh.patch
