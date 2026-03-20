#!/usr/bin/env bash
#
# Register this container with your tailnet.
# Run inside the container: ./tailscale-up.sh
#
# Customize the hostname to identify this container on your tailnet.
#
set -euo pipefail

export TS_SOCKET=/var/run/tailscale/tailscaled.sock
HOSTNAME="${1:-hackdev-jpk2}"

tailscale up \
    --ssh \
    --allow-risks=all \
    --hostname="${HOSTNAME}"
