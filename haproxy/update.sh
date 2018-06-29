#/bin/bash
set -e

IMAGE_VERSION=${IMAGE_VERSION:-1.8.12}

#-------------------------------------------------------------------------------

pushd "$(dirname $0)" >/dev/null

release_dir="release"
template_dir="../base-template"

rsync -rlDt --delete --exclude .gitkeep "$template_dir/provision" "$template_dir/static" .dockerignore provision static "$release_dir"

cat "$template_dir/Dockerfile-Alpine.template" Dockerfile.template > "$release_dir/Dockerfile"

sed -ri -e '
    s/%%FROM%%/'"haproxy:${IMAGE_VERSION}-alpine"'/g;
    s/%%IMAGE_VERSION%%/'"$IMAGE_VERSION"'/g;
    ' "$release_dir/Dockerfile"

popd >/dev/null
