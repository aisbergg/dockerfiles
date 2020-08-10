#/bin/bash
set -e

NODE_VERSIONS=(
    14.7.0  fc556b2b3f751e08d745e97bf6197d977de2a885a6080d0a731158c00ffbb02f
    12.18.3 14dafe026366e7a9cc8d4737b1fcdcb6c534667e22bbeea63a29a1791ac6ac1f
)
YARN_VERSION=1.22.4

#-------------------------------------------------------------------------------

pushd "$(dirname $0)" >/dev/null

for (( i = 0; i < ${#NODE_VERSIONS[@]}; i = i + 2 )); do
    NODE_VERSION="${NODE_VERSIONS[$i]}"
    CHECKSUM="${NODE_VERSIONS[$i+1]}"

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
        s/%%CHECKSUM%%/'"$CHECKSUM"'/g;
        ' > "$release_dir/Dockerfile"
done

popd >/dev/null
