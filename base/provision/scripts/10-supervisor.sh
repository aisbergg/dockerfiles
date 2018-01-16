#!/bin/bash
# configure the supervisor daemon

print_info "Configuring Supervisor"

# if SUPERVISOR_USER and SUPERVISOR_PW are supplied the inet_http_server is added
if [[ -n "$SUPERVISOR_USER" || -n "$SUPERVISOR_PW" ]]; then
    print_info "Adding authentication credentials to control supervisor via http connection"
fi
