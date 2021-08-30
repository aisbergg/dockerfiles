#!/usr/bin/env bash
set -eo pipefail

confirm() {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

version_greater_equal() {
    printf "%s\n%s\n" "$2" "$1" | sort --check=quiet --version-sort
}

is_latest_tag() {
    local name=$(get_name)
    local latest_tag=$(git tag | grep -E "^$name-[[:digit:]]+" | sed 's/^gitea-//' | sort -V | tail -n 1)
    version_greater_equal "$1"
}

get_name() {
    awk -F= '/^name\s*=\s*/{print $2}' .release | head -n 1
}

get_tags() {
    tags="$(awk -F= '/^tags\s*=\s*/{print $2}' .release | head -n 1)"
    # use date as tag, if none is specified
    if [ -z "$tags" ]; then
        tags=$(date -u +"%Y-%m-%d")
    fi
    # also add 'latest', if it is the latest (Git) tag
    if is_latest_tag $(echo -n "$tags" | awk '{print $1}'); then
        tags="$tags latest"
    fi
    echo -n "$tags"
}

get_tag() {
    get_tags | awk '{print $1}'
}

has_changes() {
    test -n "$(git status -s .)"
}
