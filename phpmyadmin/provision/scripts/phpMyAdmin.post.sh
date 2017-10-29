#!/bin/bash

unset BLOWFISH_SECRET

# set owner:group and permissions
chown www-data /var/lib/mysql_dumps
chmod 770 /var/lib/mysql_dumps
chown www-data:www-data -R /var/www/phpMyAdmin
chmod 660 /var/www/phpMyAdmin/config.inc.php
