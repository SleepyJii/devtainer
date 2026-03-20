#!/usr/bin/env bash
#
# Run as root on the host VM to create the jpk2 user and home directory.
#
set -euo pipefail

USERNAME="jpk2"

if id "${USERNAME}" &>/dev/null; then
    echo "==> User '${USERNAME}' already exists, skipping creation."
else
    useradd -m -s /bin/bash -G wheel "${USERNAME}"
    echo "==> Created user '${USERNAME}' with home at /home/${USERNAME}"
fi

echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}"
chmod 0440 "/etc/sudoers.d/${USERNAME}"
echo "==> Passwordless sudo configured for '${USERNAME}'"

mkdir -p "/home/${USERNAME}/devhome"
chown "${USERNAME}:${USERNAME}" "/home/${USERNAME}/devhome"
echo "==> ~/devhome ready"
