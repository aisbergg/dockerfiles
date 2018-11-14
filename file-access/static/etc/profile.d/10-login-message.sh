#!/bin/bash

function print_message() {
    # Prints a colorful message
    # Usage: print_message COLOR "Some message"
    # where COLOR can be one of: RED, YELLOW, BLUE, GREEN (default BLUE)

    local C_BLUE=`tput setaf 4`
    local C_GREEN=`tput setaf 2`
    local C_YELLOW=`tput setaf 3`
    local C_RED=`tput setaf 1`
    local C_RESET=`tput sgr0`

    local log_level="$1"
    shift
    case "$log_level" in
        RED)
            echo "${C_RED}$@${C_RESET}"
            ;;
        YELLOW)
            echo "${C_YELLOW}$@${C_RESET}"
            ;;
        BLUE)
            echo "${C_BLUE}$@${C_RESET}"
            ;;
        GREEN)
            echo "${C_GREEN}$@${C_RESET}"
            ;;
        *)
            echo "${C_BLUE}$@${C_RESET}"
            ;;
    esac
}

function print_headline() {
    # Prints a colorful headline
    # Usage: print_headline COLOR "Some message"
    # where COLOR can be one of: RED, YELLOW, BLUE, GREEN (default BLUE)

    local log_level="$1"
    shift

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
    print_message $log_level "$str"

}

#################################
# main
#################################

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
print_headline GREEN "${greeting_messages[$(expr $(shuf -i 1-${#greeting_messages[@]} -n 1) - 1)]}"

echo
print_message BLUE "Notes
====="
echo "Here you have access to the files of all services run by your organization. All the service files are neatly organized one place. You can find them in the directory: /apps

Beware that the services itself run in separated docker containers (this SSH access too), and therefore you won't be able to control the services itself. Also this SSH lives in a 'virtual' file system. Files created in your home ($HOME) or service directory (/apps) are persistent and thus they are save. Data stored in different location eventually will be lost!
"
print_message YELLOW "Important
========="
echo "This is a production environment! For your private testing and conducting experiments use your own development environment!
"
