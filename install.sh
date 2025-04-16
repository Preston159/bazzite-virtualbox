#!/usr/bin/bash
CURRENT_IMAGE="$(rpm-ostree status | grep ● | cut -d' ' -f2 | cut -d: -f1-3)"
if ! echo "$CURRENT_IMAGE" | grep "ublue-os" > /dev/null; then
  echo "It doesn't look like Bazzite is currently installed. Exiting"
  exit 1
fi
NEW_IMAGE="$(echo "$CURRENT_IMAGE" | sed -e 's@/ublue-os/bazzite@/preston159/bazzite-virtualbox@' -e 's@bazzite-virtualbox$@bazzite-virtualbox-base@' -e 's@-nvidia$@-nvidia-closed@' -e 's@-open$@@')"
echo "Rebasing from $CURRENT_IMAGE to $NEW_IMAGE"
rpm-ostree rebase "$NEW_IMAGE"
