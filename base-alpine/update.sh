#/bin/bash
set -e

IMAGE_VERSION=${IMAGE_VERSION:-3.9}

#-------------------------------------------------------------------------------

pushd "$(dirname $0)" >/dev/null

template_dir="../base-template"
release_dir="./release"

mkdir -p "$release_dir"
rsync -rlDt --delete \
    --exclude /Makefile \
    --exclude /.dockerignore \
    "$template_dir/provision" \
    "$template_dir/static" \
    "$release_dir"
cat "$template_dir/Dockerfile-Alpine.template" Dockerfile.template > "$release_dir/Dockerfile"
sed -ri -e '
    s/%%FROM%%/'"alpine:$IMAGE_VERSION"'/g;
    s/%%IMAGE_VERSION%%/'"$IMAGE_VERSION"'/g;
    ' "$release_dir/Dockerfile"
echo -e "release=${IMAGE_VERSION}\ntag=base-alpine-${IMAGE_VERSION}" > "$release_dir/.release"

popd >/dev/null
