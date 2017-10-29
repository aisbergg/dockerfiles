#!/bin/bash

# set file owner but leave the group as it is
chown -R www-data /var/www/phplist/
# confine access permissions for settings file
chmod 660 /var/www/phplist/config/config.php

# add cron job for phplist mail queue
echo -e "*/15 * * * * php /var/www/phplist/admin/index.php -pprocessqueue -c/var/www/phplist/config/config.php >/dev/null" | crontab -u root -
