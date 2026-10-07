#!/usr/bin/env bash
# Pin the esphome image in docker-compose.yaml to the latest stable release
# tag and its multi-arch (image index) digest.
#
# Usage: scripts/update-esphome-image.sh [--dry-run]
# Requires: curl, jq. Optional: GH_TOKEN/GITHUB_TOKEN (avoids GitHub API rate limits).
# In GitHub Actions, exports stable_tag and stable_digest to $GITHUB_ENV.
set -euo pipefail

REPO="esphome/esphome"
IMAGE="ghcr.io/esphome/esphome"
COMPOSE_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/docker-compose.yaml"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

gh_token="${GH_TOKEN:-${GITHUB_TOKEN:-}}"
auth=()
[[ -n "$gh_token" ]] && auth=(-H "Authorization: Bearer $gh_token")

# Latest stable release (the endpoint excludes pre-releases/betas)
tag=$(curl -fsS "${auth[@]}" "https://api.github.com/repos/${REPO}/releases/latest" | jq -r .tag_name)
if [[ ! "$tag" =~ ^[0-9]{4}\.[0-9]{1,2}\.[0-9]+$ ]]; then
  echo "Invalid release tag format: ${tag}" >&2
  exit 1
fi
echo "Latest stable tag: ${tag}"

# Digest of the image index (manifest list), which covers all architectures
registry_token=$(curl -fsS "https://ghcr.io/token?scope=repository:${REPO}:pull" | jq -r .token)
digest=$(curl -fsSI \
  -H "Authorization: Bearer ${registry_token}" \
  -H "Accept: application/vnd.oci.image.index.v1+json, application/vnd.docker.distribution.manifest.list.v2+json" \
  "https://ghcr.io/v2/${REPO}/manifests/${tag}" |
  tr -d '\r' | awk -F': ' 'tolower($1) == "docker-content-digest" {print $2}')
if [[ ! "$digest" =~ ^sha256:[0-9a-f]{64}$ ]]; then
  echo "Invalid digest: ${digest}" >&2
  exit 1
fi
echo "Multi-arch digest: ${digest}"

if [[ -n "${GITHUB_ENV:-}" ]]; then
  {
    echo "stable_tag=${tag}"
    echo "stable_digest=${digest}"
  } >>"$GITHUB_ENV"
fi

new_image="${IMAGE}:${tag}@${digest}"
current=$(sed -nE 's/^[[:space:]]*image:[[:space:]]*(ghcr\.io\/esphome\/esphome[^[:space:]]*).*/\1/p' "$COMPOSE_FILE")
if [[ "$current" == "$new_image" ]]; then
  echo "Image is already up-to-date. No changes needed."
  exit 0
fi

echo "Updating image: ${current} -> ${new_image}"
if $DRY_RUN; then
  exit 0
fi
tmp=$(mktemp)
sed -E "s|(image:[[:space:]]*)${IMAGE//./\\.}[^[:space:]]*|\1${new_image}|" "$COMPOSE_FILE" >"$tmp"
cat "$tmp" >"$COMPOSE_FILE"
rm -f "$tmp"
