#!/bin/bash

print_info "Configuring PHP7"

mkdir -p /provision/templates/etc/php/7.0/{cgi,cli}
cp /provision/templates/etc/php/7.0/php.ini.j2 /provision/templates/etc/php/7.0/cgi/php.ini.j2
cp /provision/templates/etc/php/7.0/php.ini.j2 /provision/templates/etc/php/7.0/cli/php.ini.j2
cp /provision/templates/etc/php/7.0/php.ini.j2 /provision/templates/etc/php/7.0/fpm/php.ini.j2

# create tmp upload dir
mkdir -p /var/cache/php/tmp
chown www-data -R /var/cache/php
chmod 700 -R /var/cache/php
