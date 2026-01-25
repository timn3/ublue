ARG FEDORA_MAJOR_VERSION="43"
ARG SOURCE_IMAGE="fedora-silverblue"

########################################
# Stage 1: Build Intel Lunar Lake kernel
########################################
FROM fedora:${FEDORA_MAJOR_VERSION} AS kernel-build
WORKDIR /build

RUN dnf install -y \
    git \
    gcc \
    make \
    bc \
    bison \
    flex \
    elfutils-libelf-devel \
    elfutils-devel \
    openssl-devel \
    rpm-build \
    dwarves \
    perl \
    rsync \
    tar \
    xz \
    hostname \
    iproute

RUN dnf install -y \
    openssl

# Clone Intel kernel
# RUN git clone https://github.com/intel/linux-intel-lts.git
COPY /linux-intel-lts /build/linux-intel-lts
WORKDIR /build/linux-intel-lts

COPY lnl-ipu7.config /rpmbuild/.config
RUN mkdir -p /rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} && \
    make -C /build/linux-intel-lts olddefconfig && \
    make -C /build/linux-intel-lts -j"$(nproc)" rpm-pkg
RUN ls -lh /build/linux-intel-lts/rpmbuild/RPMS/x86_64/

########################################
# Stage 2: bootc image
########################################
FROM quay.io/fedora/fedora-bootc:43

# Remove Fedora kernel
RUN dnf remove -y \
    kernel \
    kernel-core \
    kernel-modules \
    kernel-modules-extra

# Install Intel kernel RPMs

COPY --from=kernel-build /build/linux-intel-lts/rpmbuild/RPMS/x86_64/ /tmp/kernel/
RUN dnf install -y /tmp/kernel/*.rpm && rm -rf /tmp/kernel

# IPU7 firmware
COPY intel-ipu7-firmware/ /usr/lib/firmware/

# Ensure depmod ran
RUN depmod -a || true

# bootc expects no junk in /var
RUN rm -rf /var/cache/dnf /var/log/dnf*

########################################
# Final metadata
########################################
LABEL org.opencontainers.image.title="Fedora bootc Lunar Lake IPU7"
LABEL org.opencontainers.image.description="Fedora bootc with Intel Lunar Lake IPU7 kernel"
LABEL org.opencontainers.image.vendor="custom"

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
