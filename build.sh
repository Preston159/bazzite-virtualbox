#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# virtualization
rpm-ostree install edk2-ovmf
rpm-ostree install libvirt
rpm-ostree install qemu
rpm-ostree install virt-manager
# remote access
#rpm-ostree install tigervnc-server # currently non-functional
# development
curl -L -o /tmp/vscode-x64.rpm 'https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64'
rpm-ostree install /tmp/vscode-x64.rpm
# cli
rpm-ostree install zsh
curl -L -o /tmp/browsh.rpm https://github.com/browsh-org/browsh/releases/download/v1.8.0/browsh_1.8.0_linux_amd64.rpm
rpm-ostree install /tmp/browsh.rpm
