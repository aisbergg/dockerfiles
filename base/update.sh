#/bin/bash
set -e

IMAGE_VERSION_ALPINE=${IMAGE_VERSION_ALPINE:-3.7}
IMAGE_VERSION_UBUNTU=${IMAGE_VERSION_UBUNTU:-18.04}

#-------------------------------------------------------------------------------

pushd "$(dirname $0)" >/dev/null

release_dir="release"
template_dir="../base-template"

rsync -rlDt --delete .dockerignore "$template_dir/provision" "$template_dir/static" "$release_dir"

cat "$template_dir/Dockerfile-Alpine.template" Dockerfile-Alpine.template > "$release_dir/Dockerfile-Alpine"
cat "$template_dir/Dockerfile-Ubuntu.template" Dockerfile-Ubuntu.template > "$release_dir/Dockerfile-Ubuntu"

sed -ri -e '
    s/%%FROM%%/'"alpine:$IMAGE_VERSION_ALPINE"'/g;
    s/%%IMAGE_VERSION%%/'"$IMAGE_VERSION_ALPINE"'/g;
    ' "$release_dir/Dockerfile-Alpine"
sed -ri -e '
    s/%%FROM%%/'"ubuntu:$IMAGE_VERSION_UBUNTU"'/g;
    s/%%IMAGE_VERSION%%/'"$IMAGE_VERSION_UBUNTU"'/g;
    ' "$release_dir/Dockerfile-Ubuntu"

popd >/dev/null
