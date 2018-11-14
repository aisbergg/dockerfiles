#!/bin/bash
set -e

# create users, groups and set permissions
if [[ $(bool "$FORCE_SETTING_OF_ACLS" false) == true ]]; then
    force_flag="-f"
fi
if [[ -n "$CONFIG" ]]; then
    echo "$CONFIG" | python /usr/bin/setup-users-and-groups.py -c $force_flag -
elif [[ -n "$CONFIG_PATH" ]]; then
    python /usr/bin/setup-users-and-groups.py -c $force_flag "$CONFIG_PATH"
else
    print_error "No configuration specified. Use the variable CONFIG or CONFIG_PATH ."
fi
