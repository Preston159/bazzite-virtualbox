ARG SOURCE_IMAGE="bazzite"
ARG SOURCE_SUFFIX="-nvidia-open"
ARG SOURCE_TAG="stable"
ARG FLAVOR="nvidia"

FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}

COPY build.sh /tmp/build.sh

ARG FLAVOR
RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
