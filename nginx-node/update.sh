#/bin/bash
set -e

NODE_VERSIONS=(
    14.7.0
    12.18.3
)
YARN_VERSION=1.22.4

#-------------------------------------------------------------------------------

pushd "$(dirname $0)" >/dev/null

for NODE_VERSION in ${NODE_VERSIONS[@]} ; do
    release_dir="./release/${NODE_VERSION%%.*}"
    mkdir -p "$release_dir"

    echo -e "release=${NODE_VERSION}\ntag=nginx-node-${NODE_VERSION}" > "$release_dir/.release"
    cat <<-EOF > $release_dir/.dockerignore
		.release
		**/.gitkeep
		LICENSE
		Makefile
		readme-assets
		README.md
		EOF
    cat <<-EOF > $release_dir/Makefile
		include ../../../Makefile.mk

		USERNAME=aisberg
		NAME=node

		DOCKER_BUILD_ARGS=--label "org.opencontainers.image.created=\$(shell date +'%d-%m-%Y %H:%M:%S %z')"
		EOF
    cat Dockerfile.template | sed -re '
        s/%%NODE_VERSION%%/'"$NODE_VERSION"'/g;
        s/%%YARN_VERSION%%/'"$YARN_VERSION"'/g;
        ' > "$release_dir/Dockerfile"
done

popd >/dev/null
