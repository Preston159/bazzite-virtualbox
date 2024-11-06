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
  if [[ "$BUILD_VER" = "nvidia" ]]; then
    rpm-ostree install "$1"
  fi
}

# virtualization
if [[ "$BUILD_VER" = "nvidia" ]]; then
  # get kernel version using rpm; `uname -r` does not work in a container environment
  KERNEL_VER=$(/usr/libexec/rpm-ostree/wrapped/rpm -qa | grep -E 'kernel-[0-9].*?\.bazzite' | cut -d'-' -f2,3)
  KERNEL_RELEASE_VER="$(echo $KERNEL_VER | cut -d'.' -f1,2,3)"
  # .rpm name for kernel-devel
  KERNEL_DEVEL_RPM="kernel-devel-$KERNEL_VER.rpm"
  # .rpm name for kernel-devel-matched
  KERNEL_DEVEL_MATCHED_RPM="kernel-devel-matched-$KERNEL_VER.rpm"
  # download kernel-devel rpm
  curl -L -o "/tmp/$KERNEL_DEVEL_RPM" "https://github.com/hhd-dev/kernel-bazzite/releases/download/$KERNEL_RELEASE_VER/$KERNEL_DEVEL_RPM"
  # download kernel-devel-matched rpm
  curl -L -o "/tmp/$KERNEL_DEVEL_MATCHED_RPM" "https://github.com/hhd-dev/kernel-bazzite/releases/download/$KERNEL_RELEASE_VER/$KERNEL_DEVEL_MATCHED_RPM"
  # install kernel-devel and kernel-devel-matched
  rpm-ostree install "/tmp/$KERNEL_DEVEL_RPM"
  rpm-ostree install "/tmp/$KERNEL_DEVEL_MATCHED_RPM"
  # install dkms
  rpm-ostree install dkms
  # get latest version of VirtualBox
  VIRTUALBOX_VER="$(curl -L https://download.virtualbox.org/virtualbox/LATEST.TXT)"
  VIRTUALBOX_VER_URL="https://download.virtualbox.org/virtualbox/$VIRTUALBOX_VER/"
  # get Fedora versions for which packages are available, sort descending
  VIRTUALBOX_RPMS="$(curl -L "$VIRTUALBOX_VER_URL" | grep -E -o 'VirtualBox.+?fedora[0-9]+?-.+?\.x86_64\.rpm' | sed -E -e 's/">.*//' | sort -Vr)"
  for VIRTUALBOX_RPM in $VIRTUALBOX_RPMS; do
    # extract the Fedora version from the file name
    FEDORA_VERSION="$(echo $VIRTUALBOX_RPM | grep -E -o 'fedora[0-9]+' | grep -E -o '[0-9]+')"
    # if <= $RELEASE, break
    if [[ "$FEDORA_VERSION" -le "$RELEASE" ]]; then
      break
    fi
  done
  VIRTUALBOX_RPM_URL="$VIRTUALBOX_VER_URL$VIRTUALBOX_RPM"
  echo "Using '$VIRTUALBOX_RPM_URL' for Fedora $RELEASE"
  # download VirtualBox rpm
  curl -L -o "/tmp/$VIRTUALBOX_RPM" "https://download.virtualbox.org/virtualbox/$VIRTUALBOX_VER/$VIRTUALBOX_RPM"
  # install VirtualBox
  rpm-ostree install "/tmp/$VIRTUALBOX_RPM"
  # replace "uname -r" with hardcoded kernel version in VirtualBox scripts
  sed -i -e "s/uname -r/echo '$KERNEL_VER'/g" /usr/lib/virtualbox/vboxdrv.sh
  sed -i -e "s/uname -r/echo '$KERNEL_VER'/g" /usr/lib/virtualbox/check_module_dependencies.sh
  # set kernel version in vboxdrv depmod calls
  sed -i -e "s/depmod -a/depmod -v '$KERNEL_VER' -a/g" /usr/lib/virtualbox/vboxdrv.sh
  # run vboxconfig with KERN_VER set to build kernel modules
  KERN_VER="$KERNEL_VER" /sbin/vboxconfig
  # cat vbox log if it exists
  if [[ -e /var/log/vbox-setup.log ]]; then
    cat /var/log/vbox-setup.log
  fi
fi
install_desktop edk2-ovmf
install_desktop libvirt
install_desktop qemu
install_desktop virt-manager

# remote access
#rpm-ostree install tigervnc-server # currently non-functional

# development
curl -L -o /tmp/vscode-x64.rpm 'https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64'
install /tmp/vscode-x64.rpm
install_desktop docker-cli

# cli
install zsh
