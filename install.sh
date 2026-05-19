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

# Download to a temp file, sign it, then move into place.
# This avoids macOS code-signing cache issues from overwriting a running binary.
TMP="$(mktemp)"
curl -fsSL "$URL" -o "$TMP"
chmod +x "$TMP"
xattr -c "$TMP" 2>/dev/null || true
codesign --sign - --force "$TMP" 2>/dev/null || true
mv -f "$TMP" "$BINARY"

echo "Running setup..."
"$BINARY" setup
