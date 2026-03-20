#!/usr/bin/env bash
set -euo pipefail

# ── Tailscale state dirs ──────────────────────────────────────────────
mkdir -p /var/run/tailscale /var/lib/tailscale

# ── Start tailscaled ─────────────────────────────────────────────────
tailscaled \
    --tun=userspace-networking \
    --state=/var/lib/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock &

echo "==> Dev container is up. Tailscaled running."
echo "    Register with: tailscale-up.sh"

# Keep the container alive
exec sleep infinity
