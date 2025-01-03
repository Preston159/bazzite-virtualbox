# bazzite-virtualbox

Universal Blue's [bazzite] with VirtualBox, its kernel drivers, and the
Extension Pack preinstalled.

## Installing

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

## Using in your own image

If building your own image based on Universal Blue's [image template], you can
add the following to your `build.sh` script:

```bash
# install VirtualBox using script from bazzite-virtualbox
curl -L -o /tmp/vbox.sh "https://raw.githubusercontent.com/Preston159/bazzite-virtualbox/refs/heads/main/build.sh"
chmod +x /tmp/vbox.sh
/tmp/vbox.sh
```

Note that this will currently only work for images based on [bazzite].

## License Info

By using this image (excluding `-noext` flavors), you are agreeing to the terms
of the [Oracle VirtualBox Extension Pack Personal Use and Education License][puel].


[bazzite]: https://github.com/ublue-os/bazzite
[image template]: https://github.com/ublue-os/image-template
[puel]: https://www.virtualbox.org/wiki/VirtualBox_PUEL
