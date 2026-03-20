#!/usr/bin/env bash
set -euo pipefail

# ── Tailscale in userspace mode (no TUN required) ────────────────────
mkdir -p /var/run/tailscale /var/lib/tailscale
tailscaled \
    --tun=userspace-networking \
    --state=/var/lib/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock &

echo "==> Dev container is up. Tailscaled running."
echo "    Register with: tailscale up --ssh"

# Keep the container alive
exec sleep infinity
