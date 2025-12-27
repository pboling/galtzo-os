#!/usr/bin/env bash
set -euo pipefail

# Fix broken zlib symlink from zlib-devel package
# The package creates libz.so -> libz.so.1.3.1 but zlib-ng-compat
# names the actual library libz.so.1.3.1.zlib-ng
# The correct chain is: libz.so -> libz.so.1 -> libz.so.1.3.1.zlib-ng

if [ -L /usr/lib64/libz.so ] && [ ! -e /usr/lib64/libz.so ]; then
    echo "Fixing broken /usr/lib64/libz.so symlink..."
    ln -sf libz.so.1 /usr/lib64/libz.so
    echo "Fixed: libz.so -> libz.so.1"
fi
