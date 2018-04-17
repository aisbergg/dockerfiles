#!/bin/bash
set -e

unset PHPMYADMIN_BLOWFISH_SECRET

chmod o-rwx /var/www/phpMyAdmin/config.inc.php
