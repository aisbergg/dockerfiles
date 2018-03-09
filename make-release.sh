#!/bin/bash

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
    # $1 = return code
    # $2 = cleanup?
    if [[ "$2" == "y" ]]; then
        rm -r "$dest_dir"
    fi
    while popd >/dev/null 2>&1; do : ;done
    exit $1
}

function copy_dir_content_into() {
    local src_dir="$1"
    local dest_dir="$2"
    local copy_once=("README.md" "LICENSE")
    local exclude=(".git" "building_image" "Dockerfile" "~Dockerfile")

    IFS=$'\n'
    local dir_content=($(find "$1" -mindepth 1 -maxdepth 1))
    if [[ ! -d "$2" ]]; then
        mkdir -p "$2"
    fi
    for elm in "${dir_content[@]}"; do
        for excl in "${exclude[@]}"; do
            [[ "$(basename "$elm")" == "$excl" ]] && continue 2
        done
        for cpon in "${copy_once[@]}"; do
            if [[ "$(basename "$elm")" == "$cpon" ]]; then
                if [[ -e "$dest_dir/$cpon" ]]; then
                    continue 2
                fi
                continue
            fi
            [[ "$(basename "$elm")" == "$excl" ]] && continue 2
        done
        cp -af "$elm" "$2"
    done
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

function make_release() {
    local src_dir="$1"
    local dockerfile_name="$2"
    local dest_dir="$3"

    final_dockerfile=""
    make_release_recursive "$src_dir" "$dockerfile_name" "$dest_dir"

    printf "%s" "$final_dockerfile" > "$dest_dir/Dockerfile"
}

function make_release_recursive() {
    local src_dir="$1"
    local dockerfile_name="$2"
    local dest_dir="$3"

    copy_dir_content_into "$src_dir" "$dest_dir"

    # check line by line
    shopt -s extglob
    shopt -s nocasematch

    local line=""
    while IFS=$'\n' read -r line;do
        if [[ "$line" =~ ^INCLUDE[[:space:]]*?(.*)$ ]] ; then
            # check if file exists
            local include_path="${BASH_REMATCH[1]}"
            pushd "$src_dir" >/dev/null
            if [[ -d "$include_path" ]] ; then
                # find Dockerfile
                dockerfile_name=$(find_dockerfile "$include_path")
                if [[ -z "$dockerfile_name" ]]; then
                    print_error "No Dockerfile found in: $include_path"
                    Exit 1 y
                fi

                make_release_recursive "$include_path" "$dockerfile_name" "$dest_dir"
            else
                print_error "Include path does not exist: $include_path"
                Exit 1 y
            fi
            popd >/dev/null
        else
            if [[ -z "$final_dockerfile" ]]; then
                final_dockerfile="$line"
            elif [[ -z "$line" ]]; then
                final_dockerfile="$final_dockerfile
"
                # printf "%s" "$final_dockerfile"
                # exit 1
            else
                final_dockerfile="$final_dockerfile
$line"
            fi
        fi
    done < "$dockerfile_name"
}

#################################
# main
#################################

USAGE="Usage: $0 [OPTIONS] DIR_OF_TILDE_DOCKERFILE RELEASE_PATH

Create a release version of a special ~Dockerfile.

  -h, --help           Prints this help
  -f, --force          Force overwrite of RELEASE_PATH"

src_dir=""
dest_dir=""
force=""
while [[ $# > 0 ]]; do
key="$1"
case "$key" in
-h|--help)
echo "$USAGE"
exit 0
;;
-f|--force)
force="y"
shift 1
;;
*)
            break
;;
esac
done
if (( $# != 2 )); then
    echo "$USAGE"
    exit 1
else
    src_dir="$1"
    dest_dir="$2"
fi

if [[ ! -d "$src_dir" ]]; then
    print_error "Dir does not exists: $src_dir"
    exit 1
fi

# get absolute path
src_dir=$(readlink -f "$src_dir")
dest_dir=$(readlink -f "$dest_dir")

# find Dockerfile
dockerfile=$(find_dockerfile "$src_dir")
if [ -z "$dockerfile" ]; then
    print_error "No Dockerfile found in: $src_dir"
    Exit 1
fi

# guess name of image
file_head="$(head -n 1 $dockerfile)"
if [[ "$file_head" =~ ^\# ]]; then
    for image_name in $file_head; do
        if [[ "$image_name" =~ s*([a-zA-Z0-9\._-]+\/[a-zA-Z0-9\:\._-]+) ]]; then
            break
        fi
    done
fi
unset file_head
if [[ -z "$image_name" ]]; then
    image_name=$(basename "$src_dir")
fi

if [[ -e "$dest_dir" && ! -d "$dest_dir" ]]; then
    print_error "Release path exists and is not a directory: $dest_dir"
    exit 1
fi

if [[ -d "$dest_dir" ]]; then
    if [[ "$force" == "y" ]]; then
        rm -r "$dest_dir"
    else
        print_error "Directory exists: $dest_dir"
        print_error "Use parameter '-f' to overwrite it"
        exit 1
    fi
fi
mkdir -p "$dest_dir"

make_release "$src_dir" "$dockerfile" "$dest_dir"

print_ok "Successfully created a release for '$image_name' in '$dest_dir'$"
Exit 0;
