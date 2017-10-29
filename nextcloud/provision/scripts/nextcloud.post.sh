#!/bin/bash

# exit on errors
set -e

# create temp dir
mkdir -p -m 700 /tmp/nextcloudtemp /var/cache/nginx
chown www-data:www-data /tmp/nextcloudtemp /var/cache/nginx

if [[ ! -f /var/www/nextcloud/config/config.php ]]; then
    # when freshly created then copy the automatically created config file
    cp /usr/local/src/config.php /var/www/nextcloud/config/config.php
else
    # merge nextcloud configuration with automatically created config file
    python /provision/helper/merge_nextcloud_configurations.py /var/www/nextcloud/config/config.php /usr/local/src/config.php /var/www/nextcloud/config/merged-config.php
    if ! cmp -s /var/www/nextcloud/config/merged-config.php /var/www/nextcloud/config/config.php; then
        # config changed --> backup current config file and replace it
        mv -f /var/www/nextcloud/config/config.php "/var/www/nextcloud/config/config_$(date +%F_%R).php"
        mv /var/www/nextcloud/config/merged-config.php /var/www/nextcloud/config/config.php
    else
        # config did not change
        rm /var/www/nextcloud/config/merged-config.php
    fi
fi
rm /usr/local/src/config.php

# confine access permissions for config file
chmod 660 /var/www/nextcloud/config/config.php
chown www-data /var/www/nextcloud/config/config.php

# add cron job
echo "*/15 * * * * php -f /var/www/nextcloud/cron.php >> /var/lib/nextcloud/cron.log 2>&1" | crontab -u www-data -

if [ -f /var/www/nextcloud/.needs-upgrade ]; then
    # call upgrade routine
    cd /var/www/nextcloud
    su -s /bin/sh www-data -c "php occ upgrade"
    # remove upgrade indicator if upgrade succeeded
    rm /var/www/nextcloud/.needs-upgrade
fi
