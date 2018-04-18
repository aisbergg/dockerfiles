#!/bin/bash

# exit on errors
set -e

print_info "Configuring MkDocs"

# install additional python packages (e.g. mkdocs extensions)
if [ -n "$ADDITIONAL_PYTHON_PACKAGES" ]; then
    for pkg in $ADDITIONAL_PYTHON_PACKAGES; do
        pip install "$pkg"
    done
fi

# add cron job
if [ -z "$CRON_JOB_SCHEDULE" ]; then
    CRON_JOB_SCHEDULE="*/5 * * * *"
fi
echo -e "$CRON_JOB_SCHEDULE ssh-agent /home/mkdocs/build_site.sh >/dev/null" | crontab -u mkdocs -

# create dir for serving html
mkdir -p -m 770 /var/www/docs
chown www-data:www-data /var/www/docs
