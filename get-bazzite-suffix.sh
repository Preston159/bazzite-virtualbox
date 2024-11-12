#!/bin/bash

set -ouex pipefail

case "$flavor" in
  "base")
    SUFFIX="";;
  *nvidia)
    SUFFIX="-$flavor-open";;
  *)
    SUFFIX="-$flavor";;
esac

echo "suffix=$SUFFIX" >> $GITHUB_OUTPUT

UPSTREAM="ghcr.io/ublue-os/bazzite$SUFFIX:latest"
docker pull "$UPSTREAM"
UPSTREAM_VER="$(docker inspect "$UPSTREAM" | jq -r '.[0].Config.Labels["org.opencontainers.image.version"]')"
echo "upstream_ver=$UPSTREAM_VER" >> $GITHUB_OUTPUT
