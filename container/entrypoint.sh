#!/usr/bin/env bash
set -euo pipefail

# ── Tailscale in userspace mode (no TUN required) ────────────────────
mkdir -p /var/run/tailscale /var/lib/tailscale
tailscaled \
    --tun=userspace-networking \
    --state=/var/lib/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock &

# ── Start SSHD ──────────────────────────────────────────────────────
/usr/sbin/sshd -D &

echo "==> Dev container is up. Tailscaled + SSHD running."

# Keep the container alive
exec sleep infinity
