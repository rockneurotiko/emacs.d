#!/usr/bin/env bash
# Build Emacs 30.2 patched for tree-sitter 0.26 compatibility.
#
# Problem: tree-sitter 0.25+ renamed query predicates (#match -> #match?,
# #equal -> #eq?, #pred -> #pred?) and 0.26 removed the old names entirely.
# Emacs 30.2 still uses the old names, causing treesit-query-error on every
# tree-sitter mode.
#
# Patches (backported from Emacs master, via Gentoo/Arch):
#   01_all_treesit-0.26.patch - Compilation fix (ts_language_version removed)
#   02_all_ts-query-pred.patch - Predicate rename (#match -> #match?, etc.)
#
# References:
#   https://bugs.gnu.org/79687
#   https://bugs.gentoo.org/970856
#   https://bugs.gentoo.org/971731

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EMACS_VERSION="30.2"
SRC_DIR="${SCRIPT_DIR}/emacs-${EMACS_VERSION}"

echo "==> Downloading Emacs ${EMACS_VERSION} source..."
cd "$SCRIPT_DIR"
if [ ! -f "emacs-${EMACS_VERSION}.tar.xz" ]; then
    curl -LO "https://ftp.gnu.org/gnu/emacs/emacs-${EMACS_VERSION}.tar.xz"
fi

echo "==> Extracting..."
rm -rf "$SRC_DIR"
tar xf "emacs-${EMACS_VERSION}.tar.xz"

echo "==> Applying patches..."
cd "$SRC_DIR"
patch -Np1 < "${SCRIPT_DIR}/01_all_treesit-0.26.patch"
patch -Np1 < "${SCRIPT_DIR}/02_all_ts-query-pred.patch"

echo "==> Configuring..."
./configure \
    --prefix=/usr/local \
    --with-native-compilation=aot \
    --with-tree-sitter \
    --with-json \
    --with-pgtk \
    --with-modules \
    --with-gnutls \
    --with-mailutils \
    "$@"

echo "==> Building (this will take a while)..."
make -j"$(nproc)"

echo ""
echo "==> Build complete!"
echo "    Install with: cd ${SRC_DIR} && sudo make install"
echo "    Or run directly: ${SRC_DIR}/src/emacs"
