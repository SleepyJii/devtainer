#!/usr/bin/env bash
#
# Build the Docker image and export it as an Apptainer SIF file
# in the project root.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "${SCRIPT_DIR}")"
IMAGE_NAME="hackathon-dev"
SIF_FILE="${REPO_ROOT}/${IMAGE_NAME}.sif"

echo "==> Building Docker image '${IMAGE_NAME}'..."
docker build -t "${IMAGE_NAME}:latest" "${REPO_ROOT}/container"

echo "==> Exporting to SIF: ${SIF_FILE}"
apptainer build "${SIF_FILE}" "docker-daemon://${IMAGE_NAME}:latest"

echo ""
echo "==> Done: ${SIF_FILE}"
echo "   Launch with: ./container/apptainer-run.sh ${SIF_FILE}"
