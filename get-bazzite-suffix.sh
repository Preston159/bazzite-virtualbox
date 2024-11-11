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
