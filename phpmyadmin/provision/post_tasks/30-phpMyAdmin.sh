#!/bin/bash
set -e

unset PHPMYADMIN_BLOWFISH_SECRET

chmod o-rwx /data/www/config.inc.php
