#!/bin/bash

function print_log() {
    # Prints a log message.
    # Usage: print_log "Message" "LOG_TYPE"
    # where LOG_TYPE is one of: INFO, WARN, ERROR, DEBG
    local pid=$(echo $$)
    if [[ "$WEBDAV_PRINT_LOG" == True ]]; then
        echo "$(date +"%Y-%d-%m %T,%3N") ${pid} [$2] WebDAV-Sync $1"
    fi
}

function print_info() {
    # Prints an info message.
    # Usage: print_info "message"
    print_log "$1" INFO
}

function print_error() {
    # Prints an error message.
    # Usage: print_error "message"
    print_log "$1" ERROR
}

_exit() {
    rm $STDERR_FILE
    exit ${1:-0}
}
trap _exit INT TERM

STDERR_FILE="$(mktemp /tmp/$(basename $0).XXXXXXXXXX)"
exec 3>$STDERR_FILE

# get list of parameter files
parameter_files_dir=/etc/supervisor/conf.d/webdav-sync-parameter
parameter_files=(`ls -1 $parameter_files_dir/*.env`)

# Create local paths if they do not exist
for pfile in "${parameter_files[@]}"; do
    source $pfile
    if ! mkdir -p "$WEBDAV_LOCAL_PATH" 2>&3; then
        err="$(<"$STDERR_FILE")"
        print_error "Failed to create local path: $err"
        _exit 1
    fi
done

# Create excludes and unsyncedfolders lists
for pfile in "${parameter_files[@]}"; do
    number="${pfile##*/}"
    number="${number%.*}"
    source $pfile
    IFS=';' read -r -a WEBDAV_EXCLUDES <<< "$WEBDAV_EXCLUDES"
    IFS=';' read -r -a WEBDAV_UNSYNCED_FOLDERS <<< "$WEBDAV_UNSYNCED_FOLDERS"
    IFS=$'\n'
    echo > "$parameter_files_dir/excludes_$number.lst"
    echo > "$parameter_files_dir/unsynced_folders_$number.lst"
    if [[ ${#WEBDAV_EXCLUDES} > 0 ]]; then
        for exclude in "${WEBDAV_EXCLUDES[@]}"; do
            echo "$exclude" >> "$parameter_files_dir/excludes_$number.lst"
        done
    fi
    if [[ ${#WEBDAV_UNSYNCED_FOLDERS} > 0 ]]; then
        for unsynced_folder in "${WEBDAV_UNSYNCED_FOLDERS[@]}"; do
            echo "$unsynced_folder" >> "$parameter_files_dir/unsynced_folders_$number.lst"
        done
    fi
done

while true; do
    for pfile in "${parameter_files[@]}"; do
        number="${pfile##*/}"
        number="${number%.*}"
        source $pfile
        print_info "Running WebDAV-Sync ($number)..."
        if /usr/bin/nextcloudcmd \
                -u "$WEBDAV_USER" \
                -p "$WEBDAV_PASSWORD" \
                --exclude "$parameter_files_dir/excludes_$number.lst" \
                --unsyncedfolders "$parameter_files_dir/unsynced_folders_$number.lst" \
                "$WEBDAV_LOCAL_PATH" \
                "$WEBDAV_REMOTE_URL" 2>&3; then
            print_info "Synchronization successful ($number)"
        else
            err="$(<"$STDERR_FILE")"
            print_error "Synchronization faild ($number): $err"
        fi
    done
    sleep $WEBDAV_SYNC_INTERVAL
done
