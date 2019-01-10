#!/bin/bash
set -e

unset PHPMYADMIN_BLOWFISH_SECRET

chmod o-rwx /container/www/config.inc.php || true
