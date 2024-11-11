# bazzite-virtualbox

Universal Blue's [bazzite] with VirtualBox and its kernel drivers preinstalled.

To install, first install [bazzite], then run
`rpm-ostree rebase ostree-image-signed:docker://ghcr.io/preston159/bazzite-[flavor]`.
The flavor should generally match the tag of the bazzite image you currently
have installed (which can be checked by running `rpm-ostree status`), except
`-open` should be removed for nvidia versions, as the non-`-open` nvidia
versions of bazzite are not built in this repo at this time. If they are added
in the future, a different suffix will be used such that `x-nvidia` versions
are still based on `x-nvidia-open`.


[bazzite]: https://github.com/ublue-os/bazzite
