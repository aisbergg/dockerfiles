#!/bin/bash
# script version 1.11

#################################
# console output colors
#################################

C_INFO=$(tput setaf 4)
C_OK=$(tput setaf 2)
C_WARN=$(tput setaf 3)
C_ERROR=$(tput setaf 1)
C_RESET=$(tput sgr0)

#################################
# functions
#################################

function printINFO() {
    echo "${C_INFO}$1${C_RESET}"
}

function printERROR() {
    echo "${C_ERROR}$1${C_RESET}"
}

function printWARN() {
    echo "${C_WARN}$1${C_RESET}"
}

function printOK() {
    echo "${C_OK}$1${C_RESET}"
}

function Exit() {
    rm "$STDERR_FILE"
    if [[ $keep_build_dir != True ]]; then
        rm -r "$script_dir/building_image"
    fi
    exit $1
}

function checkForErrors() {
    ERR="$(<"$STDERR_FILE")"
    if [ -n "$ERR"  ]; then
        printERROR "Error ocourred!"
		echo "$ERR"
		return 0
    fi
    return 1
}

function cleanup() {
    cd "$1"
    rm -r "building_image/"
}

function copyDirContentInto() {
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

function findDockerFile() {
    local dockerfile_names=("dockerfile" "~dockerfile")
    for dockerfile_name in "${dockerfile_names[@]}"; do
        local files=($(find . -maxdepth 1 -type f -iname "$dockerfile_name" | sed -e "s/^\.\///g"))
        if (( ${#files[@]} > 0 )); then
            echo "${files[0]}"
            return
        fi
    done
}

function parseDockerFile() {
    # $1 == file path
    # $2 == 0 if orginial file (not an included one) otherwise 1
    unset ret
    # read file content
    IFS=$'\n'
    local dockerfile_content=($(cat "$1" 2>&3))

    if ( checkForErrors ); then
        cleanup "$cur_path"
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
                local cur_path="$(pwd)"
                cd "$include_path"
                # find Dockerfile
                dockerfile=$(findDockerFile)
                if [ -z "$dockerfile" ]; then
                    printERROR "No valid Dockerfile found in $include_path!"
                    cleanup "$cur_path"
                    ret="1"
                    return
                fi

                # create working copy
                copyDirContentInto . building_image/
                parseDockerFile "$dockerfile" 1
                if [ -n "$ret" ]; then
                    cleanup "$cur_path"
                    ret="1"
                    return
                fi

                cd "$cur_path"

                # copy content from include path
                copyDirContentInto "${include_path}/building_image/" "${cur_path}/building_image/"
                rm -r "${include_path}/building_image" 2>&3
            else
                printWARN "The include path '$include_path' does not exist"
            fi
        # skip from include
        elif [[ "$2" == 1 && "$line" =~ ^[[:space:]]*?FROM.*$ ]] ; then
            :
        # skip maintainer include
        elif [[ "$2" == 1 && "$line" =~ ^[[:space:]]*?MAINTAINER.*$ ]] ; then
            :
        else
            final_dockerfile=("${final_dockerfile[@]}" "$line")
        fi
        let i++
    done
}

#################################
# main
#################################

# go into script directory
cd "$(dirname $0)"
script_dir="$(pwd)"
# for redirecting stderr
STDERR_FILE="$(mktemp /tmp/$(basename $0).XXXXXXXXXX)"
exec 3>$STDERR_FILE

USAGE="Usage: $0 [OPTIONS]

Build docker image from Dockerfile in directory of the script

  -h, --help           Prints this help
  -n, --no-cache       Disable docker build caching ( build from scratch )
  -k, --keep-build-dir Keep the dir used for building the image"

no_cache_flag="--no-cache=false"
while [[ $# > 0 ]] ; do
	key="$1"
	case $key in
		--) # No more options left.
			shift 1
			break
			;;
		-h|--help)
			echo "$USAGE"
			exit 0
			;;
		-n|--no-cache)
			no_cache_flag="--no-cache=true"
			shift 1
			;;
    -k|--keep-build-dir)
			keep_build_dir=True
			shift 1
			;;
		*) # unknown option
			shift 1
			;;
	esac
done

# find Dockerfile
dockerfile=$(findDockerFile)
if [ -z "$dockerfile" ]; then
    printERROR "No Dockerfile found!"
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
    printERROR "Name for image not defined. The name must be specified in the first line of the 'Dockerfile' as a comment."
    exit 1
fi

printINFO "Building image '${image_names[0]}'..."

# create working copy
if [ -d "./building_image/" ]; then
    rm -r "building_image/"
fi
copyDirContentInto . building_image/

parseDockerFile "$dockerfile" 0
if [ -n "$ret" ]; then
    printERROR "Building of '${image_names[0]}' failed!"
    Exit 1
fi

cd "./building_image/"
printf "%s\n" "${final_dockerfile[@]}" > Dockerfile

# build Docker image
if docker build --rm "$no_cache_flag" -t "${image_names[0]}" . ; then
    printOK "Successfully built '${image_names[0]}'"
    for (( i = 1; i < ${#image_names[@]}; i++ )); do
        docker tag "${image_names[0]}" "${image_names[$i]}" 1>/dev/null
        printOK "Added tag '${image_names[$i]}'"
    done
else
    printERROR "Failed to build '${image_names[0]}'"
    cd ..
    Exit 1
fi
cd ..
Exit 0;
