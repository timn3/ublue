#!/usr/bin/env bash
# Env vars (optional overrides):
#   RUST_TOOLCHAIN   default: stable
#   RUST_PROFILE     default: default   (minimal|default|complete)
#
set -euo pipefail

RUST_TOOLCHAIN="${RUST_TOOLCHAIN:-stable}"
RUST_PROFILE="${RUST_PROFILE:-default}"

export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH="/usr/local/cargo/bin:${PATH}"

echo "==> Installing build dependencies via dnf"
dnf install -y\
    gcc \
    gcc-c++ \
    make \
    pkgconf-pkg-config \
    openssl-devel \
    curl
dnf clean all

echo "==> Installing rustup (toolchain=${RUST_TOOLCHAIN}, profile=${RUST_PROFILE})"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y \
        --default-toolchain "${RUST_TOOLCHAIN}" \
        --profile "${RUST_PROFILE}" \
        --no-modify-path

echo "==> Fixing permissions so all users can read/execute the toolchain"
chmod -R a+rX "${RUSTUP_HOME}" "${CARGO_HOME}"

echo "==> Writing /etc/profile.d/rust.sh for login shells"
cat > /etc/profile.d/rust.sh <<'EOF'
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME="$HOME/.cargo"
export PATH="$HOME/.cargo/bin:/usr/local/cargo/bin:$PATH"
EOF
chmod 644 /etc/profile.d/rust.sh

echo "==> Verifying install"
rustc --version
cargo --version

echo "==> Rust toolchain installed successfully into ${CARGO_HOME}"