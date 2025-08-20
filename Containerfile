ARG BASE_IMAGE_NAME="bluefin"
ARG FEDORA_MAJOR_VERSION="42"
ARG SOURCE_IMAGE="${BASE_IMAGE_NAME}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}-dx-nvidia"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
# COPY /system_files /system_files
COPY /build_files /build_files
# COPY /iso_files /iso_files
COPY /flatpaks /flatpaks
# COPY /just /just
COPY packages.json /

# Base Image
FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS base
# FROM ghcr.io/ublue-os/silverblue-nvidia:latest

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/shared/build_base.sh && \
    ostree container commit

# FROM base as dev

# RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#     --mount=type=cache,dst=/var/cache \
#     --mount=type=cache,dst=/var/log \
#     --mount=type=tmpfs,dst=/tmp \
#     /ctx/build_files/shared/build_dev.sh && \
#     ostree container commit

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
