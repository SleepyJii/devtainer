#!/usr/bin/env bash
set -euo pipefail

# ── Tailscale state dirs ──────────────────────────────────────────────
mkdir -p /var/run/tailscale /var/lib/tailscale

# ── Run as jpk2 ──────────────────────────────────────────────────────
exec su jpk2 -c '
    tailscaled \
        --tun=userspace-networking \
        --state=/var/lib/tailscale/tailscaled.state \
        --socket=/var/run/tailscale/tailscaled.sock &

    echo "==> Dev container is up. Tailscaled running as jpk2."
    echo "    Register with: tailscale-up.sh"

    sleep infinity
'
