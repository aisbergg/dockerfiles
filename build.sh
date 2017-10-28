#!/bin/bash
# script version 1.11

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

function Exit() {
    # cleanup
    rm -r "$STDERR_FILE" "$dir_containing_dockerfile/building_image"
    popd >/dev/null
    exit $1
}

function check_for_errors() {
    ERR="$(<"$STDERR_FILE")"
    if [ -n "$ERR"  ]; then
        print_error "Error ocourred!"
		echo "$ERR"
		return 0
    fi
    return 1
}

function copy_dir_content_into() {
    local old_IFS=$IFS
    IFS=$'\n'
    local dir_content=($(find "$1" -mindepth 1 -maxdepth 1))
    if [[ ! -d "$2" ]]; then
        mkdir -p "$2"
    fi
    for elm in "${dir_content[@]}"; do
        # exclude .git
        if [[ "$elm" != ./.git ]]; then
            cp -af "$elm" "$2"
        fi
    done
    IFS=$old_IFS
}

function find_dockerfile() {
    local dockerfile_names=("dockerfile" "~dockerfile")
    for dockerfile_name in "${dockerfile_names[@]}"; do
        local files=($(find . -maxdepth 1 -type f -iname "$dockerfile_name" | sed -e "s/^\.\///g"))
        if (( ${#files[@]} > 0 )); then
            echo "${files[0]}"
            return
        fi
    done
}

function parse_dockerfile() {
    # $1 == file path
    # $2 == 0 if orginial file (not an included one) otherwise 1
    unset ret
    # read file content
    IFS=$'\n'
    local dockerfile_content=($(cat "$1" 2>&3))

    if ( check_for_errors ); then
        ret="1"
        return
    fi

    # check line by line
    shopt -s extglob
    shopt -s nocasematch

    local i=0
    while (( i < ${#dockerfile_content[*]} )); do
        local line="${dockerfile_content[$i]}"
        if [[ "$line" =~ ^INCLUDE[[:space:]]*?(.*)$ ]] ; then
            # check if file exists
            local include_path="${BASH_REMATCH[1]}"
            if [ -d "$include_path" ] ; then
                pushd "$include_path" >/dev/null
                # find Dockerfile
                dockerfile=`find_dockerfile`
                if [ -z "$dockerfile" ]; then
                    print_error "No valid Dockerfile found in $include_path!"
                    popd >/dev/null
                    ret="1"
                    return
                fi

                # create working copy
                copy_dir_content_into . building_image/
                parse_dockerfile "$dockerfile" 1
                if [ -n "$ret" ]; then
                    rm -r "$(pwd)/building_image" 2>&3
                    popd >/dev/null
                    ret="1"
                    return
                fi

                popd >/dev/null

                # copy content from include path
                copy_dir_content_into "${include_path}/building_image/" "$(pwd)/building_image/"
                rm -r "${include_path}/building_image" 2>&3
            else
                print_warning "The include path '$include_path' does not exist"
            fi
        # skip from include
        elif [[ "$2" == 1 && "$line" =~ ^[[:space:]]*?FROM.*$ ]] ; then
            :
        else
            final_dockerfile+=("$line")
        fi
        let i++
    done
}

#################################
# main
#################################

# for redirecting stderr
STDERR_FILE="$(mktemp /tmp/$(basename $0).XXXXXXXXXX)"
exec 3>$STDERR_FILE

USAGE="Usage: $0 [OPTIONS] DIR_CONTAINING_DOCKERFILE

Build docker image from a Dockerfile.

  -h, --help           Prints this help
  -n, --no-cache       Disable docker build caching ( build from scratch )
  -m RELEASE_PATH, --make-release RELEASE_PATH
                       Create a release version of a special ~Dockerfile"

no_cache_flag="--no-cache=false"
dir_containing_dockerfile=""
make_release_path=""
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
        -m|--make-release)
		    make_release_path=$2
			shift 2
			;;
		*) # unknown option
            if [[ $# = 1 ]]; then
                dir_containing_dockerfile="$key"
                break
            fi
            shift 1
			;;
	esac
done
if [[ -z "$dir_containing_dockerfile" ]]; then
    echo "$USAGE"
    exit 1
fi
if [[ ! -d "$dir_containing_dockerfile" ]]; then
    print_error "Dir does not exists: $dir_containing_dockerfile"
    exit 1
fi

# get absolute path
dir_containing_dockerfile=`readlink -f "$dir_containing_dockerfile"`

pushd "$dir_containing_dockerfile" >/dev/null

# find Dockerfile
dockerfile=`find_dockerfile`
if [ -z "$dockerfile" ]; then
    print_error "No Dockerfile found!"
    Exit 1
fi

# get image name and additional tags from the comment in the first line
file_head="$(head -n 1 $dockerfile)"
if [[ "$file_head" =~ ^\# ]]; then
    for image_name in $file_head; do
        if [[ "$image_name" =~ s*([a-zA-Z0-9\._-]+\/[a-zA-Z0-9\:\._-]+) ]]; then
            image_names=("${image_names[@]}" "$image_name")
        fi
    done
fi
unset file_head
if [[ ${#image_names[@]} == 0 ]]; then
    print_error "Name for image not defined. The name must be specified in the first line of the 'Dockerfile' as a comment."
    exit 1
fi

print_info "Building image '${image_names[0]}'..."

# create working copy
if [ -d "./building_image/" ]; then
    rm -r "building_image/"
fi
copy_dir_content_into . building_image/

parse_dockerfile "$dockerfile" 0
if [ -n "$ret" ]; then
    print_error "Building of '${image_names[0]}' failed!"
    Exit 1
fi

cd "./building_image/"
printf "%s\n" "${final_dockerfile[@]}" > Dockerfile

# build Docker image
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
Exit 0;
