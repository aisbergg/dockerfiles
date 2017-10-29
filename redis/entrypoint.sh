#!/bin/bash

# exit on errors
set -e

# some useful functions
###############################################################################
function print_log() {
    # Prints a log message.
    # Usage: print_log "Message" "LOG_TYPE"
    # where LOG_TYPE is one of: INFO, WARN, ERROR, DEBG
    local pid=$(echo $$)
    echo "$(date +"%Y-%d-%m %T,%3N") ${pid} [$2] ContainerProvisioning $1"
}

function print_warning() {
    # Prints a warning message.
    # Usage: print_warning "message"
    print_log "$1" WARN
}

function print_debug() {
    # Prints a debug message.
    # Usage: print_debug "message"
    print_log "$1" DEBUG
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

function convert_to_upper_case() {
    # Converts a string to uppercase.
    # Usage: string=`convert_to_upper_case "$string"`
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

function convert_to_lower_case() {
    # Converts a string to lowercase.
    # Usage: string=`convert_to_lower_case "$string"`
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

function standardise_bool() {
    # Converts from various bool styles to a standardized one.
    # It will convert those:
    #   true, on, yes, y, 1 --> True
    #   false, off, no, n, 0 --> False
    # When the given value doesn't match any of the above the default value
    # will be used. The default value is specified by the second parameter.
    # Usage: bool=`standardise_bool "$bool" True`
    local bool=`convert_to_lower_case "$1"`
    if [[ "$bool" == "true" || "$bool" == "on" || "$bool" == "yes" || "$bool" == "y" || "$bool" == "1" ]]; then
        echo True
    elif [[ "$bool" == "false" || "$bool" == "off" || "$bool" == "no" || "$bool" == "n" || "$bool" == "0" ]]; then
        echo False
    else
        echo "$2"
    fi
}

function export_bool() {
    # Standardize bool envs or sets them to default value and exports them again.
    # It takes an array with alternating order of variable name and default
    # value.
    # Usage:
    # bools=(
    #    FirstVar False
    #    SecondVar True
    #    ThirdVar Flase
    # )
    # export_bool bools[@]
    local bools=("${!1}")
    for (( i=0; i < ${#bools[@]}; i=i+2 )); do
        eval export "${bools[$i]}=\"`standardise_bool "${!bools[$i]}" "${bools[$i+1]}" `\""
    done
}

function default() {
    # Checks if the given parameter matches any of the possible values. If it
    # does not match any then the default value will be used.
    # Usage: param=`default "$param" default_value possible_value1 ... possible_valueN`
    local param=`convert_to_lower_case "$1"`
    local default_value="$2"
    if [ -z "$1" ]; then
        echo "$default_value"
        return 0
    else
        shift 2
        local possible_values=( $@ )
        for pv in ${possible_values[@]}; do
            if [ "$param" == "$pv" ]; then
                echo "$pv"
                return 0
            fi
        done
    fi
}

function is_dir_empty() {
    # Checks wheter a dir is empty.
    # Usage: if is_dir_empty /some/dir; then ...; fi
    if [ -e "$1" ]; then
        if [[ -d "$1" && `ls -1A "$1" | wc -l` -eq 0 ]]; then
            return 0
        else
            return 1
        fi
    else
        return 0
    fi
}

function merge_dirs() {
    # Merges two dirs by simply copying non existing files and dirs from the
    # root of a given source.
    # Usage: merge_dirs /merge/from /into/dest/dir
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        print_error "Failed to merge '$src' into '$dest'. Source does not exist!"
        exit 1
    fi
    if [ ! -d "$src" ]; then
        print_error "Failed to merge '$src' into '$dest'. Source is not a dir!"
        exit 1
    fi
    if [ ! -e "$dest" ]; then
        mkdir -p "$dest"
    fi
    if [[ ! -d "$dest" ]]; then
        print_error "Failed to merge '$src' into '$dest'. Destination is not a dir!"
        exit 1
    fi

    # create list of files and dirs that exist in src dir
    local old_cwd="$(pwd)"
    cd "$src"
    local relative_file_paths=($(find . -maxdepth 1 -type f | sed -e "s/^\.\///g"))
    local relative_dir_paths=($(find . -maxdepth 1 -type d | sed -e "s/^\.\///g"))
    cd "$old_cwd"

    # copy non existing files
    for rel_file_path in ${relative_file_paths[@]}; do
        if [ ! -e "${dest}/${rel_file_path}" ]; then
            cp -a "${src}/${rel_file_path}" "${dest}/${rel_file_path}"
        fi
    done

    # copy non existing dirs
    for rel_dir_path in ${relative_dir_paths[@]}; do
        if [ ! -e "${dest}/${rel_dir_path}" ]; then
            cp -a "${src}/${rel_dir_path}" "${dest}/${rel_dir_path}"
        fi
    done
}

function copy_autogenerated_files() {
    # Copies a file and replaces existing ones if not specified otherwise. To
    # prevent overwriting there must be a comment in the very first line of the
    # target file. The comment must include the command 'autogen' like this for
    # example: '# autogen false'
    # 'autogen' can also be one of those: False, FALSE, off, no, n
    # Usage: copy_autogenerated_files /src/dir /dest/dir

    if [ -f "$2" ]; then
        local header="$(head -n 1 "$2")"
        if [[ "$header" =~ autogen[[:blank:]]+([^[:blank:]]+) ]]; then
            local autogen=`standardise_bool "${BASH_REMATCH[1]}" True`
        fi
    fi
    if [ "$autogen" != False ]; then
        mkdir -p "$(dirname "$2")"
        cp -af "$1" "$2"
    fi
}
###############################################################################

USAGE="Usage: $0 [OPTIONS] [COMMAND] [ADDITIONAL_ENVS]

Provision the container and run the applications.

Options:
  -h, --help           Prints this help

Commands:
  debug                Run container in debug mode
  provision            Provions the container (only in debug mode)
  run                  Start the applications (only in debug mode)"

if [ -f /debug_mode ]; then
    set -a
    . /debug_mode
    set +a
fi

# parse cli args
while [[ $# > 0 ]]; do
    arg="$1"
    case $arg in
      -h|--help)
        echo "$USAGE"
        exit 0
        ;;
      container_start)
        container_start=True
        shift 1
        ;;
      debug)
        if [[ ! debug == True ]]; then
          debug_mode=True
          echo "debug_mode=True" >> /debug_mode
        fi
        print_warning "Entered debug mode"
        shift 1
        ;;
      provision)
        provision=True
        shift 1
        ;;
      run)
        run=True
        shift 1
        ;;
      *) # parse key=value pair and export as environment variable
        if [[ "$1" =~ ^([^\=]*)=(.*)$ ]]; then
            key="${BASH_REMATCH[1]%%*( )}" # assign and remove trailing whitespaces
            val="${BASH_REMATCH[2]%%*( )}"
            val="${val#\"}" # remove leading quote
            val="${val%\"}" # remove trailing quote
            if [[ -n "$key" ]]; then
                # add new set of variable=replacement
                keys=("${keys[@]}" "$key")
                export "${key}=${val}"
                if [[ "$debug_mode" == True ]]; then
                    echo "${key}='${val//\'/\'\\\'\'}'" >> /debug_mode
                fi
            fi
            unset key
            unset val
        fi
        shift 1
        ;;
    esac
done

if [[ ! "$debug_mode" == True || "$provision" == True ]]; then
    if [ -d /provision ]; then
        # fix permissions
        find /provision -type f -exec chmod 0664 {} +
        find /provision -type d -exec chmod 0775 {} + 

        # execute individual provision scripts (bash or python);
        # files ending with *.post.{sh,py} will be executed later on
        print_info "Running individual provision scripts"
        for script in /provision/scripts/*.{sh,py}; do
            if [ -n "$(echo "$script" | grep -P '(?<!\.post)\.(sh|py)$')" ]; then
                test -r "$script" && . "$script"
            fi
        done

        # render templates
        print_info "Render templates"
        cd /provision/
        templer -f -p /provision/templates /provision/contexts

        # copy newly rendered templates to their destination, but skip files that
        # are not supposed to be autogenerated (autogen false)
        print_info "Copying files to their destination"
        cd /provision/templates
        relative_file_paths=("$(find . -type f -not -name '*.j2' | sed -e "s/^\.\///g")")
        for rel_path in ${relative_file_paths[@]}; do
            copy_autogenerated_files "/provision/templates/${rel_path}" "/${rel_path}"
        done
        unset relative_file_paths

        # execute post provision scripts (bash or python) ending with
        # *.post.{sh,py}
        print_info "Running post provision scripts"
        for post_scripts in /provision/scripts/*.post.{sh,py}; do
            test -r "$post_scripts" && . "$post_scripts"
        done

        # unset keys
        for key in ${keys[@]}; do
            unset "$key"
        done
        unset keys

        if [[ ! "$debug_mode" == True ]]; then
            # cleanup everything
            print_info "Cleaning up"
            rm -rf /provision
            cd ~
        fi
    fi
fi

if [[ ! "$debug_mode" == True || "$run" == True ]]; then
    # execute supervisor
    print_info "Starting supervisor"
    exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
elif [[ "$container_start" == True ]]; then
    # drop into bash
    exec /bin/bash
fi