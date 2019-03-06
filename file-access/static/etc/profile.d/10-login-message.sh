#!/bin/bash

local C_BLUE=`tput setaf 4`
local C_GREEN=`tput setaf 2`
local C_YELLOW=`tput setaf 3`
local C_RED=`tput setaf 1`
local C_RESET=`tput sgr0`

function print_headline() {
    # format string
    local input_str="$@"
    local term_cols=$(tput cols)
    let spaces_count=$term_cols-${#input_str}
    local str="$(eval "printf '#'%.0s {1..$term_cols}")
#>>>"
    let leading_spaces_count=($spaces_count/2-4)
    let trailing_spaces_count=$spaces_count-$leading_spaces_count-8
    str+="$(eval "printf ' '%.0s {1..$leading_spaces_count}")"
    str+="$input_str"
    str+="$(eval "printf ' '%.0s {1..$trailing_spaces_count}")"
    str+="<<<#
"
    str+="$(eval "printf '#'%.0s {1..$term_cols}")"

    # printing the formatted message
    echo  "${C_GREEN}${str}${C_RESET}"

}

greeting_messages=(
    "Welcome, good to see you again!"
    "Konnichiwa"
    "Aloha, how are you doing?"
    "Want to get some work done, eh?"
    "What's cookin', good lookin'? ;)"
    "Wubba lubba dub dub"
    "G'day mate! How you going?"
    "How's it going, mate?"
    "Here's Johnny!"
)

clear
print_headline "${greeting_messages[$(expr $(shuf -i 1-${#greeting_messages[@]} -n 1) - 1)]}"

echo "${C_BLUE}Notes
=====${C_RESET}
This Secure Shell (SSH) provides file access to services run by your organization. All service data is neatly organized and can be found in the directory '/apps'. Newly created files in '/apps' or '$HOME' will be persistent, however files created in different places might be deleted at anytime.

Webservers and other programs cannot be controled through this SSH access. If you help any help ask the administrator for assistance.

${C_YELLOW}Important
=========${C_RESET}
This is a production environment! Therefore this is not a place for experiments and private testing. For development use your own environment at home!
"
