# bazzite-virtualbox

Universal Blue's [bazzite] with VirtualBox and its kernel drivers preinstalled.

To install, first install [bazzite], then run:
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/preston159/bazzite-virtualbox-[flavor]
```

The flavor should generally match the tag of the bazzite image you currently
have installed (e.g. `bazzite-xyz` -> `bazzite-virtualbox-xyz`), with a few
exceptions:
- `bazzite` -> `bazzite-virtualbox-base`
- `bazzite-xyz-nvidia-open` -> `bazzite-virtualbox-xyz-nvidia` (remove the `-open`)
  - The non-`open` nvidia versions of bazzite are not currently built in this
    repository. If they are added in the future, a different suffix will be
    used such that `xyz-nvidia` versions are still based on `xyz-nvidia-open`.

You can check which version of bazzite you currently have installed by running:
```bash
rpm-ostree status
```


[bazzite]: https://github.com/ublue-os/bazzite
