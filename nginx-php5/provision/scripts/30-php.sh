#!/bin/bash

print_info "Configuring PHP5"

mkdir -p /provision/templates/etc/php/5.6/{cgi,cli}
cp /provision/templates/etc/php/5.6/php.ini.j2 /provision/templates/etc/php/5.6/cgi/php.ini.j2
cp /provision/templates/etc/php/5.6/php.ini.j2 /provision/templates/etc/php/5.6/cli/php.ini.j2
cp /provision/templates/etc/php/5.6/php.ini.j2 /provision/templates/etc/php/5.6/fpm/php.ini.j2

# create tmp upload dir
mkdir -p /var/cache/php/tmp
chown www-data -R /var/cache/php
chmod 700 -R /var/cache/php
