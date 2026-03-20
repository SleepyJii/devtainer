#!/usr/bin/env bash
set -euo pipefail

# ── Tailscale state dirs (created as root before dropping privileges) ─
mkdir -p /var/run/tailscale /var/lib/tailscale
chown jpk2:jpk2 /var/run/tailscale /var/lib/tailscale

# ── Drop to jpk2 and run everything from here ────────────────────────
exec su jpk2 -c '
    tailscaled \
        --tun=userspace-networking \
        --state=/var/lib/tailscale/tailscaled.state \
        --socket=/var/run/tailscale/tailscaled.sock &

    echo "==> Dev container is up. Tailscaled running as jpk2."
    echo "    Register with: tailscale-up.sh"

    sleep infinity
'
