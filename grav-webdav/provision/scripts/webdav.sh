#!/bin/bash

print_info "Configuring WebDAV-Sync"

WEBDAV_SYNC_INTERVAL=${WEBDAV_SYNC_INTERVAL:-60}
WEBDAV_PRINT_LOG=`standardise_bool "$WEBDAV_PRINT_LOG" False`

function val(){
    local varname="$1_`printf "%02d" $2`"
    if [[ -z "${!varname}" ]]; then
        echo "$3"
    else
        echo "${!varname}"
    fi
}

function add_parameters_file() {
    local number=`printf "%02d" $1`
    cat >> /etc/supervisor/conf.d/webdav-sync-parameter/${number}.env <<EOF
WEBDAV_LOCAL_PATH="$2"
WEBDAV_REMOTE_URL="$3"
WEBDAV_USER="$4"
WEBDAV_PASSWORD="$5"
WEBDAV_EXCLUDES="$6"
WEBDAV_UNSYNCED_FOLDERS="$7"
WEBDAV_SYNC_INTERVAL="$8"
WEBDAV_PRINT_LOG="$9"
EOF
    chown www-data:www-data /etc/supervisor/conf.d/webdav-sync-parameter/${number}.env
    chmod 0400 /etc/supervisor/conf.d/webdav-sync-parameter/${number}.env
}

mkdir -p /etc/supervisor/conf.d/webdav-sync-parameter
chown www-data:www-data /etc/supervisor/conf.d/webdav-sync-parameter
c=1
while [[ -n "`val WEBDAV_REMOTE_URL $c`" ]]; do
    add_parameters_file $c "`val WEBDAV_LOCAL_PATH $c`" "`val WEBDAV_REMOTE_URL $c`" "`val WEBDAV_USER $c`" "`val WEBDAV_PASSWORD $c`" "`val WEBDAV_EXCLUDES $c`" "`val WEBDAV_UNSYNCED_FOLDERS $c`" "`val WEBDAV_SYNC_INTERVAL $c $WEBDAV_SYNC_INTERVAL`" $WEBDAV_PRINT_LOG
    let "c++"
done
