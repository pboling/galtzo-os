#!/usr/bin/env bash
set -euo pipefail

# 1Password RPM scriptlets create these as regular groups if absent. In an
# image build that can allocate GIDs that later collide with real user groups.
for group in onepassword onepassword-cli onepassword-mcp; do
    if ! getent group "${group}" >/dev/null; then
        groupadd --system "${group}"
    fi
done
