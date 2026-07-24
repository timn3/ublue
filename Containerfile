ARG FEDORA_MAJOR_VERSION="44"
ARG SOURCE_IMAGE="fedora-silverblue"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY /scripts /scripts
COPY /flatpaks /flatpaks
COPY /system_files /system_files
COPY /dotfiles /dotfiles
COPY /binaries /binaries


# Base Image
FROM quay.io/fedora/${SOURCE_IMAGE}:${FEDORA_MAJOR_VERSION} AS base

# Make sure that the rootfiles package can be installed
RUN mkdir -p /var/roothome

# Stage 1: Base OS setup
FROM base AS base_os

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/base_os.sh && \
    ostree container commit

# Stage 2: Preparation for desktop runtime 
FROM base_os AS desktop_wm
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/desktop_wm.sh && \
    ostree container commit

# Stage 3: Desktop runtime
FROM desktop_wm AS desktop_runtime

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/desktop_runtime.sh && \
    ostree container commit

# Stage 4: Desktop apps
FROM desktop_runtime AS desktop_apps

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/desktop_apps.sh && \
    ostree container commit

# Stage 5: Desktop extras
FROM desktop_apps AS desktop_extras

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/desktop_extras.sh && \
    ostree container commit

# Stage 6: User configuration
FROM desktop_extras AS user_config

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/user_config.sh && \
    ostree container commit

# Stage 7: Cleanup
FROM user_config AS final

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/cleanup.sh && \
    ostree container commit

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
