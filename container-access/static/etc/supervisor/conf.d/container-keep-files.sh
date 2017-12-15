#!/bin/bash

keep_files_dir=/root/container-keep-files

# create array of files and dirs to keep
IFS=' ' # can be anything but \n, so readarray will work
readarray flines <<< `cat "${keep_files_dir}/filelist" | sed -e 's/^[[:space:]]*//'`
IFS=$'\n'
for fline in ${flines[@]}; do
    if [[ -n "$fline" && "$fline" != \#* ]]; then
        files_to_keep=("$fline" ${files_to_keep[@]})
    fi
done

if [[ "$1" == wait-for-changes ]]; then
    exec when-changed -r ${files_to_keep[@]} -c bash /etc/supervisor/conf.d/container-keep-files.sh
fi

# create lockfile
lockfile="${keep_files_dir}/container-keep-files.lock"
if [[ -f "$lockfile" ]]; then
    if [[ -z "`head -n1 "$lockfile"`" ]]; then
        echo "1" > "$lockfile"
        while [[ -f "$lockfile" ]]; do sleep 5; done
    else
        exit 0
    fi
fi
touch "$lockfile"

# save acls
getfacl -R ${files_to_keep[@]} > "${keep_files_dir}/acls"
# save files and dirs
tar -cpzf "${keep_files_dir}/files.tgz" --directory=/ ${files_to_keep[@]} > /dev/null
chmod 600 "${keep_files_dir}/files.tgz" "${keep_files_dir}/acls"

# remove lockfile
rm "$lockfile"
