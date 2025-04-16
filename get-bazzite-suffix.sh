#!/bin/bash

set -ouex pipefail

case "$flavor" in
  "base")
    SUFFIX="";;
  *nvidia-closed)
    SUFFIX="-${flavor/-closed/}";;
  *nvidia)
    SUFFIX="-$flavor-open";;
  *)
    SUFFIX="-$flavor";;
esac

UPSTREAM="ghcr.io/ublue-os/bazzite$SUFFIX:latest"
echo "upstream=$UPSTREAM" >> $GITHUB_OUTPUT
docker pull "$UPSTREAM"
UPSTREAM_VER="$(docker inspect "$UPSTREAM" | jq -r '.[0].Config.Labels["org.opencontainers.image.version"]')"
echo "upstream_ver=$UPSTREAM_VER" >> $GITHUB_OUTPUT
