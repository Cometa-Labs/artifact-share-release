#!/bin/bash
set -e

REPO="Cometa-Labs/artifact-share-release"
INSTALL_DIR="$HOME/.local/bin"
BINARY="$INSTALL_DIR/artifact-share"

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  arm64)  ASSET="artifact-share" ;;
  x86_64) ASSET="artifact-share-x64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Get latest release download URL
URL="https://github.com/$REPO/releases/latest/download/$ASSET"

echo "Downloading artifact-share ($ARCH)..."
mkdir -p "$INSTALL_DIR"
curl -fsSL "$URL" -o "$BINARY"
chmod +x "$BINARY"

# Strip quarantine and ad-hoc sign so Gatekeeper allows execution
xattr -c "$BINARY" 2>/dev/null || true
codesign --sign - --force "$BINARY" 2>/dev/null || true

echo "Running setup..."
"$BINARY" setup
