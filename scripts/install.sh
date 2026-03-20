#!/usr/bin/env bash
#
# Build the dev container image and ensure Apptainer is available.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "${SCRIPT_DIR}")"

# ── Build Docker image ───────────────────────────────────────────────
echo "==> Building hackathon-dev Docker image..."
docker build -t hackathon-dev:latest "${REPO_ROOT}/container"

# ── Check / install Apptainer ────────────────────────────────────────
if command -v apptainer &>/dev/null; then
    echo "==> Apptainer already installed: $(apptainer --version)"
else
    echo "==> Apptainer not found. Installing..."
    if command -v dnf &>/dev/null; then
        sudo dnf install -y apptainer
    elif command -v apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y apptainer
    else
        echo "ERROR: Unsupported package manager. Install Apptainer manually:"
        echo "  https://apptainer.org/docs/admin/main/installation.html"
        exit 1
    fi
    echo "==> Apptainer installed: $(apptainer --version)"
fi

# ── Create devhome ───────────────────────────────────────────────────
mkdir -p "${HOME}/devhome"

echo ""
echo "==> Setup complete!"
echo "    Run the container with:  ${REPO_ROOT}/container/apptainer-run.sh"
