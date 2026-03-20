#!/usr/bin/env bash
#
# Launch the dev container via Apptainer with:
#   - host Docker socket mounted
#   - ~/devhome bound to container /home/jpk2
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "${SCRIPT_DIR}")"
IMAGE="${1:-${REPO_ROOT}/hackathon-dev.sif}"
INSTANCE_NAME="${2:-hackdev}"
DEVHOME="${HOME}/devhome"
TS_STATE="${HOME}/tailscale-state"

mkdir -p "${DEVHOME}" "${TS_STATE}"

echo "==> Starting dev container as instance '${INSTANCE_NAME}'..."
echo "    Image:   ${IMAGE}"
echo "    Devhome: ${DEVHOME} -> /home/jpk2"
echo "    Docker:  /var/run/docker.sock (host)"

apptainer instance start \
    --bind /var/run/docker.sock:/var/run/docker.sock \
    --bind "${DEVHOME}":/home/jpk2 \
    --bind "${TS_STATE}":/var/lib/tailscale \
    --writable-tmpfs \
    --containall \
    "${IMAGE}" \
    "${INSTANCE_NAME}"

echo ""
echo "==> Instance '${INSTANCE_NAME}' is running."
echo "    Shell into it:     apptainer shell instance://${INSTANCE_NAME}"
echo "    Exec a command:    apptainer exec instance://${INSTANCE_NAME} <cmd>"
echo "    Tailscale login:   apptainer exec instance://${INSTANCE_NAME} tailscale up"
echo "    Stop it:           apptainer instance stop ${INSTANCE_NAME}"
