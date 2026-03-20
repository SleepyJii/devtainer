#!/usr/bin/env bash
#
# Launch the dev container via Apptainer with:
#   - host Docker socket mounted
#   - ~/devhome bound to container /home/jpk2
#
set -euo pipefail

IMAGE="${1:-docker://localhost/hackathon-dev:latest}"
INSTANCE_NAME="${2:-hackdev}"
DEVHOME="${HOME}/devhome"

mkdir -p "${DEVHOME}"

echo "==> Starting dev container as instance '${INSTANCE_NAME}'..."
echo "    Image:   ${IMAGE}"
echo "    Devhome: ${DEVHOME} -> /home/jpk2"
echo "    Docker:  /var/run/docker.sock (host)"

apptainer instance start \
    --bind /var/run/docker.sock:/var/run/docker.sock \
    --bind "${DEVHOME}":/home/jpk2 \
    --writable-tmpfs \
    --no-home \
    --net \
    --network-args "portmap=2222:22/tcp" \
    "${IMAGE}" \
    "${INSTANCE_NAME}"

echo ""
echo "==> Instance '${INSTANCE_NAME}' is running."
echo "    Shell into it:     apptainer shell instance://${INSTANCE_NAME}"
echo "    Exec a command:    apptainer exec instance://${INSTANCE_NAME} <cmd>"
echo "    Tailscale login:   apptainer exec instance://${INSTANCE_NAME} tailscale up"
echo "    Stop it:           apptainer instance stop ${INSTANCE_NAME}"
