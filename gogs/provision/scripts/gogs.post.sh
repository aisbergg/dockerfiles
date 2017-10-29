#!/bin/bash

unset SECRET_KEY

# set owner:group and permissions
chown git:git -R /var/lib/gogs /opt/gogs
chmod 660 /opt/gogs/custom/conf/app.ini
