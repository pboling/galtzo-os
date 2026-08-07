#!/usr/bin/env bash
set -euo pipefail

# virt-manager normally discovers qemu:///system only. Galtzo-OS also uses
# qemu:///session for user-owned VM images, so make both local inventories
# visible and connect to both on startup for every user by default.
install -d -m 0755 /etc/dconf/db/local.d
cat > /etc/dconf/db/local.d/20-galtzo-virt-manager <<'EOF'
[org/virt-manager/virt-manager/connections]
uris=['qemu:///session', 'qemu:///system']
autoconnect=['qemu:///session', 'qemu:///system']
EOF

if command -v dconf >/dev/null 2>&1; then
    dconf update
fi
