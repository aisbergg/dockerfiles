#!/bin/bash

mkdir -p /var/lib/teamspeak-server/logs
mkdir -p /var/lib/teamspeak-server/files
ln -sf /var/lib/teamspeak-server/files /opt/teamspeak

TS_FILES=(
    licensekey.dat
    query_ip_whitelist.txt
    query_ip_blacklist.txt
    serverkey.dat
    ts3server.ini
    ts3server.sqlitedb
    ts3server.sqlitedb-shm
    ts3server.sqlitedb-wal
)
for ts_file in ${TS_FILES[@]}; do
    touch /var/lib/teamspeak-server/$ts_file
    ln -sf /var/lib/teamspeak-server/$ts_file /opt/teamspeak/$ts_file
done

exec /opt/teamspeak/ts3server_minimal_runscript.sh "logpath=/var/lib/teamspeak-server/logs" "license_accepted=1"
