#!/bin/bash
set -e

REPO="Cometa-Labs/artifact-share-release"
INSTALL_DIR="$HOME/.local/bin"
BINARY="$INSTALL_DIR/artifact-share"
TOKEN_FILE="$HOME/.config/cometa-artifact-share/token.json"
PREFS_FILE="$HOME/.artifact-share/prefs.json"

# Parse flags
CLEAN=false
for arg in "$@"; do
  case "$arg" in
    --clean) CLEAN=true ;;
  esac
done

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

# Clear stored credentials and preferences on clean install
if [ "$CLEAN" = true ]; then
  echo "Clearing previous credentials..."
  rm -f "$TOKEN_FILE"
  rm -f "$PREFS_FILE"
fi

echo "Running setup..."
"$BINARY" setup
