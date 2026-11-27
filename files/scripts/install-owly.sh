#!/usr/bin/env bash
set -euo pipefail

# Install the latest Owly RPM from GitHub Releases (AirDrop/AWDL over Linux Wi-Fi).
# Follow the /releases/latest redirect instead of calling api.github.com so daily
# GitHub Actions builds do not hit unauthenticated API rate limits.
latest_url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/t4t5/owly/releases/latest)"
tag="${latest_url##*/}"
version="${tag#v}"

if [ -z "${version}" ] || [ "${version}" = "latest" ]; then
    echo "Failed to resolve latest owly release tag from ${latest_url}" >&2
    exit 1
fi

rpm_name="owly-${version}-1.x86_64.rpm"
rpm_url="https://github.com/t4t5/owly/releases/download/${tag}/${rpm_name}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

echo "Installing ${rpm_name} from ${rpm_url}..."
curl -fsSL -o "${tmp_dir}/${rpm_name}" "${rpm_url}"
# Keep weak deps enabled so dnf pulls in hostapd (recommended by owly).
dnf install -y --no-gpgchecks "${tmp_dir}/${rpm_name}"
dnf clean all
