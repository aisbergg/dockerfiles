#!/bin/bash

print_info "Configuring WebDAV"

## Variables:
# WEBDAV_CRON_SCHEDULE_XX
# WEBDAV_LOCAL_PATH_XX
# WEBDAV_REMOTE_URL_XX
# WEBDAV_USER_XX
# WEBDAV_PASSWORD_XX

function val(){
    local varname="$1_`printf "%02d" $2`"
    echo "${!varname}"
}

c=1
while [[ -n "`val WEBDAV_PASSWORD $c`" ]]; do
    echo "`val WEBDAV_CRON_SCHEDULE $c` nextcloudcmd -u \"`val WEBDAV_USER $c`\" -p \"`val WEBDAV_PASSWORD $c`\" --silent \"`val WEBDAV_LOCAL_PATH $c`\" \"`val WEBDAV_REMOTE_URL $c`\"" | crontab -u www-data -
    let "c++"
done
