ARG FEDORA_MAJOR_VERSION="44"
ARG SOURCE_IMAGE="fedora-silverblue"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY /build /build
COPY /flatpaks /flatpaks
COPY /system_files /system_files
COPY /dotfiles /dotfiles

# Base Image
FROM quay.io/fedora/${SOURCE_IMAGE}:${FEDORA_MAJOR_VERSION} AS base

# Make sure that the rootfiles package can be installed
RUN mkdir -p /var/roothome

# Stage 0: Setting up repositories
FROM base AS base_repo

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/00-repo.sh && \
    ostree container commit

# Stage 1: Configuring codecs and multimedia support
FROM base_repo AS base_codecs

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/01-codecs.sh && \
    ostree container commit

# Stage 2: Base OS setup
FROM base_codecs AS base_os

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/02-base.sh && \
    ostree container commit

# Stage 3: Desktop Environment setup
FROM base_os AS desktop

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/03-desktop.sh && \
    ostree container commit

# Stage 4: Hyprland setup
FROM desktop AS desktop_hyprland

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/04-hyprland.sh && \
    ostree container commit

# Stage 5: Install applications
FROM desktop_hyprland AS desktop_applications

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/05-applications.sh && \
    ostree container commit

# Stage 6: Finialize image
FROM desktop_applications AS finalized_os

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/06-finalize.sh && \
    ostree container commit

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
