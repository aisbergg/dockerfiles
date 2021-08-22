#/bin/bash
set -e

NODE_VERSIONS=(
    16.7.0  616e4cdf07aa64d2c4a4653b753a4ec9b2ee4febca8b195ebf82e8f22de67641
    14.17.5 8889a3ea0d0d8247132cf257ccd4828ddcd7e373f67c875878035b131e9fa1ac
    12.22.5 1c8ce0d58828faff84486dc116ec817595841c8578ed01266eb69e5383c73201
)
YARN_VERSION=1.22.5

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
