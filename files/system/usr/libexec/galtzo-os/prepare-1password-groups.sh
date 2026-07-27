#!/usr/bin/env bash
set -euo pipefail

# Keep persistent /etc/group aligned with the immutable image's 1Password
# helper ownerships. This repairs upgraded ostree systems where package
# scriptlet-created groups collided with local groups.
while read -r group gid; do
    existing_name="$(getent group "${gid}" | cut -d: -f1 || true)"
    if [ -n "${existing_name}" ] && [ "${existing_name}" != "${group}" ]; then
        echo "GID ${gid} is already used by ${existing_name}; cannot assign ${group}" >&2
        exit 1
    fi

    if getent group "${group}" >/dev/null; then
        current_gid="$(getent group "${group}" | cut -d: -f3)"
        if [ "${current_gid}" != "${gid}" ]; then
            groupmod --gid "${gid}" "${group}"
        fi
    else
        groupadd --gid "${gid}" "${group}"
    fi
done <<'GROUPS'
onepassword 61001
onepassword-cli 61002
onepassword-mcp 61003
GROUPS
