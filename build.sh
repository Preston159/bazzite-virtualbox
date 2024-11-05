#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

BUILD_VER="$1"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# installs a given package on all versions
install () {
  rpm-ostree install "$1"
}

# installs a given package only on the desktop version
install_desktop () {
  if [[ "$BUILD_VER" = "desktop" ]]; then
    rpm-ostree install "$1"
  fi
}

# virtualization
install_desktop edk2-ovmf
install_desktop libvirt
install_desktop qemu
install_desktop virt-manager
if [[ "$BUILD_VER" = "desktop" ]]; then
  KERNEL_VER=$(/usr/libexec/rpm-ostree/wrapped/rpm -qa | grep -E 'kernel-[0-9].*?\.bazzite' | cut -d'-' -f2,3)
  KERNEL_DEVEL_RPM="kernel-devel-$KERNEL_VER.rpm"
  KERNEL_DEVEL_MATCHED_RPM="kernel-devel-matched-$KERNEL_VER.rpm"
  curl -L -o "/tmp/$KERNEL_DEVEL_RPM" "https://github.com/hhd-dev/kernel-bazzite/releases/download/$(echo $KERNEL_VER | cut -d'.' -f1,2,3)/$KERNEL_DEVEL_RPM"
  curl -L -o "/tmp/$KERNEL_DEVEL_MATCHED_RPM" "https://github.com/hhd-dev/kernel-bazzite/releases/download/$(echo $KERNEL_VER | cut -d'.' -f1,2,3)/$KERNEL_DEVEL_MATCHED_RPM"
  rpm-ostree install "/tmp/$KERNEL_DEVEL_RPM"
  rpm-ostree install "/tmp/$KERNEL_DEVEL_MATCHED_RPM"
  rpm-ostree install dkms
  VIRTUALBOX_VER=$(curl -L https://download.virtualbox.org/virtualbox/LATEST.TXT)
  VIRTUALBOX_RPM=$(curl -L "https://download.virtualbox.org/virtualbox/$VIRTUALBOX_VER/" | grep -E 'VirtualBox.+?fedora40.+?\.rpm' | sed -E -e 's/[^<]+<a href="//' | sed -E -e 's/">.+//')
  curl -L -o "/tmp/$VIRTUALBOX_RPM" "https://download.virtualbox.org/virtualbox/$VIRTUALBOX_VER/$VIRTUALBOX_RPM"
  rpm-ostree install "/tmp/$VIRTUALBOX_RPM"
fi
# remote access
#rpm-ostree install tigervnc-server # currently non-functional
# development
curl -L -o /tmp/vscode-x64.rpm 'https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64'
install /tmp/vscode-x64.rpm
install_desktop docker-cli
# cli
install zsh
