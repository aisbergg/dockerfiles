#!/usr/bin/env bash
set -eo pipefail

IMAGE_VERSION=3.14

(
cd "$(dirname $0)"
template_dir="../base-template"

rsync -rlDt --delete $template_dir/provision/ ./provision/
rsync -rlDt --delete $template_dir/static/ ./static/
cat $template_dir/Dockerfile-Alpine.tpl Dockerfile.tpl > Dockerfile
sed -ri "s/%%FROM%%/alpine:$IMAGE_VERSION/g;s/%%IMAGE_VERSION%%/$IMAGE_VERSION/g;" Dockerfile
echo -e "name=base-alpine\ntags=${IMAGE_VERSION}" > .release
)
