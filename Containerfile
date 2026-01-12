ARG FEDORA_MAJOR_VERSION="43"
ARG SOURCE_IMAGE="fedora-silverblue"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY /scripts /scripts
COPY /flatpaks /flatpaks
COPY /system_files /system_files
COPY /dotfiles /dotfiles

# Base Image
FROM quay.io/fedora/${SOURCE_IMAGE}:${FEDORA_MAJOR_VERSION} AS base

# Make sure that the rootfiles package can be installed
RUN mkdir -p /var/roothome

# Stage 1: Base OS setup
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/build_base.sh && \
    ostree container commit

# Stage 2: User setup
FROM base AS desktop_setup

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/desktop_setup.sh && \
    ostree container commit

# Stage 3: User configuration
FROM desktop_setup AS user_config

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/user_config.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
