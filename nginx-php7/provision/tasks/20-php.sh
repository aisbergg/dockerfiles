#!/bin/bash

print_info "Configuring PHP7"

# export timezone variable to be used in PHP date/time functions
export TZ=$(php -r 'echo timezone_name_from_abbr(exec("date +%Z"));')
