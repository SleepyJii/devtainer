#!/usr/bin/env bash
#
# Mount a remote project directory into ~/devhome/project via sshfs,
# or fall back to a one-shot rsync if sshfs is unavailable.
#
# Usage:
#   ./mount-project.sh user@host:/path/to/shared-project
#   ./mount-project.sh user@host:/path/to/shared-project [local-name]
#
set -euo pipefail

# ── Configuration (edit these or pass as args) ───────────────────────
REMOTE="${1:?Usage: $0 user@host:/remote/path [local-name]}"
LOCAL_NAME="${2:-project}"
MOUNT_POINT="${HOME}/devhome/${LOCAL_NAME}"

mkdir -p "${MOUNT_POINT}"

# ── Parse remote ─────────────────────────────────────────────────────
REMOTE_HOST="${REMOTE%%:*}"
REMOTE_PATH="${REMOTE#*:}"

echo "==> Mounting ${REMOTE_HOST}:${REMOTE_PATH} -> ${MOUNT_POINT}"

# ── Prefer sshfs (live mount) ────────────────────────────────────────
if command -v sshfs &>/dev/null; then
    sshfs \
        -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        "${REMOTE_HOST}:${REMOTE_PATH}" \
        "${MOUNT_POINT}"
    echo "==> Mounted via sshfs. Unmount with: fusermount -u ${MOUNT_POINT}"
else
    echo "==> sshfs not found, falling back to rsync (one-shot copy)."
    rsync -avz --progress \
        "${REMOTE_HOST}:${REMOTE_PATH}/" \
        "${MOUNT_POINT}/"
    echo "==> Synced. Re-run to pull updates, or install sshfs for a live mount."
fi
