#!/bin/bash

# exit on errors
set -e

print_info "Configuring work environment for control container"

print_info "Restoring container files"
keep_files_dir="/root/container-keep-files"
if [[ -f "${keep_files_dir}/files.tgz" ]]; then
    pushd / > /dev/null
    tar -xzf "${keep_files_dir}/files.tgz" > /dev/null
    # restore permissions
    setfacl --restore="${keep_files_dir}/acls"
    popd > /dev/null
fi
unset keep_files_dir

print_info "Tweaking some options"
# increase number of rounds for password hashing
sed -ri "s/^# SHA_CRYPT_MIN_ROUNDS.*\$/SHA_CRYPT_MIN_ROUNDS 20000/g" /etc/login.defs
# enable umlauts
locale-gen --purge de_DE.UTF-8

print_info "Adding environmental variables"
# add some docker environment variables for ssh-sessions
add_envs="PERSISTENT_DIRS=$PERSISTENT_DIRS
COMPOSITION_NAME=$COMPOSITION_NAME
SUPERVISOR_USER=$SUPERVISOR_USER
SUPERVISOR_PW=$SUPERVISOR_PW
CONTAINERS_IN_SAME_COMPOSITION=$CONTAINERS_IN_SAME_COMPOSITION
PATH=$PATH:/usr/sbin"
echo "$add_envs" | sed -e 's/^/export \"/' | sed -e 's/$/\"/' > "/etc/profile.d/0-container-envs.sh"
unset add_envs
