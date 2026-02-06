#!/usr/bin/env bash
set -euo pipefail

# https://edu.chainguard.dev/open-source/sigstore/cosign/how-to-install-cosign/#installing-cosign-with-the-cosign-binary
# Download the most recent binary:
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"

# Next, move the Cosign binary to your bin folder:
sudo mv cosign-linux-amd64 /usr/local/bin/cosign

# Finally, update permissions so that Cosign can execute within your filesystem:
sudo chmod +x /usr/local/bin/cosign