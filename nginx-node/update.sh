#/bin/bash
set -e

NODE_VERSIONS=(
    10.6.0
    9.11.2
    8.11.3
)
YARN_VERSION=1.7.0

#-------------------------------------------------------------------------------

pushd "$(dirname $0)" >/dev/null

release_dir="release"

mkdir -p "$release_dir"
cp .dockerignore "$release_dir"

for NODE_VERSION in ${NODE_VERSIONS[@]} ; do
    df_dest="$release_dir/Dockerfile-Node-${NODE_VERSION%%.*}"
    cat Dockerfile.template > "$df_dest"
    sed -ri -e '
        s/%%NODE_VERSION%%/'"$NODE_VERSION"'/g;
        s/%%YARN_VERSION%%/'"$YARN_VERSION"'/g;
        ' "$df_dest"
done

popd >/dev/null
