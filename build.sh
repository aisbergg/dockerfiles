#!/bin/bash

#################################
# console output colors
#################################

C_INFO=`tput setaf 4`
C_OK=`tput setaf 2`
C_WARN=`tput setaf 3`
C_ERROR=`tput setaf 1`
C_RESET=`tput sgr0`

#################################
# functions
#################################

function print_info() {
    echo "${C_INFO}$1${C_RESET}"
}

function print_error() {
    echo "${C_ERROR}$1${C_RESET}"
}

function print_warning() {
    echo "${C_WARN}$1${C_RESET}"
}

function print_ok() {
    echo "${C_OK}$1${C_RESET}"
}

function cleanup() {
    while popd >/dev/null 2>&1; do : ;done
    rm -rf "$src_dir/building_image"
}

function Exit() {
    # $1 = return code
    cleanup
    exit $1
}

function find_dockerfile() {
    local dockerfile_names=("dockerfile" "~dockerfile")
    for dockerfile_name in "${dockerfile_names[@]}"; do
        local files=($(find "$1" -maxdepth 1 -type f -iname "$dockerfile_name" | sed -e "s/^\.\///g"))
        if (( ${#files[@]} > 0 )); then
            echo "${files[0]}"
            return
        fi
    done
}

#################################
# main
#################################

cd "$(dirname $0)"

USAGE="Usage: $0 [OPTIONS] DIR_CONTAINING_DOCKERFILE...

Build docker image from a Dockerfile.

  -h, --help           Prints this help
  -n, --no-cache       Disable docker build caching ( build from scratch )"

no_cache_flag="--no-cache=false"
src_dir=""
while [[ $# > 0 ]]; do
  	key="$1"
  	case "$key" in
    		-h|--help)
    			echo "$USAGE"
    			exit 0
    			;;
    		-n|--no-cache)
    			no_cache_flag="--no-cache=true"
    			shift 1
    			;;
    		*)
                break
    			;;
  	esac
done
if (( $# == 0 )); then
    echo "$USAGE"
    exit 1
else
    src_dir="$1"
fi

while [[ -n "$1" ]]; do
    # get absolute path
    src_dir=`readlink -f "$1"`

    # find Dockerfile
    dockerfile=`find_dockerfile "$src_dir"`
    if [ -z "$dockerfile" ]; then
        print_error "No Dockerfile found in: $src_dir"
        Exit 1
    fi

    # get image name and additional tags from the comment in the first line
    file_head="$(head -n 1 $dockerfile)"
    image_names=()
    if [[ "$file_head" =~ ^\# ]]; then
        for image_name in $file_head; do
            if [[ "$image_name" =~ s*([a-zA-Z0-9\._-]+\/[a-zA-Z0-9\:\._-]+) ]]; then
                image_names+=("$image_name")
            fi
        done
    fi
    unset file_head
    if [[ ${#image_names[@]} == 0 ]]; then
        print_error "Name for image not defined. The name must be specified in the first line of the 'Dockerfile' as a comment."
        exit 1
    fi

    bash ./make-release.sh -f "$src_dir" "$src_dir/building_image"

    # build Docker image
    print_info "Building image '${image_names[0]}'..."
    pushd "$src_dir/building_image" >/dev/null
    if docker build --rm "$no_cache_flag" -t "${image_names[0]}" . ; then
        print_ok "Successfully built '${image_names[0]}'"
        for (( i = 1; i < ${#image_names[@]}; i++ )); do
            docker tag "${image_names[0]}" "${image_names[$i]}" 1>/dev/null
            print_ok "Added tag '${image_names[$i]}'"
        done
    else
        print_error "Failed to build '${image_names[0]}'"
        Exit 1
    fi
    cleanup

    shift 1
done

Exit 0;
