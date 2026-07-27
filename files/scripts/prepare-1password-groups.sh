#!/usr/bin/env bash
set -euo pipefail

# 1Password RPM scriptlets create these groups if absent, and the helpers rely
# on matching group ownership for desktop/CLI integration. In an ostree image,
# allocator-chosen low system GIDs can later collide with persistent /etc/group
# entries on upgraded machines, so pin them outside the normal local range.
while read -r group gid; do
    if getent group "${gid}" >/dev/null && [ "$(getent group "${gid}" | cut -d: -f1)" != "${group}" ]; then
        echo "GID ${gid} is already used by $(getent group "${gid}" | cut -d: -f1); cannot assign ${group}" >&2
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
