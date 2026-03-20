FROM fedora:41

# ── Core packages ────────────────────────────────────────────────────
RUN dnf install -y \
        python3 python3-pip \
        tmux vim neovim tree \
        git curl wget unzip jq \
        openssh-clients \
        iptables procps-ng sudo \
        nodejs npm \
    && dnf clean all

# ── Docker CLI + Compose (client only – we bind-mount the host socket) ─
RUN dnf install -y dnf-plugins-core \
    && dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo \
    && dnf install -y docker-ce-cli docker-compose-plugin \
    && dnf clean all

# ── Tailscale ────────────────────────────────────────────────────────
RUN dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo \
    && dnf install -y tailscale \
    && dnf clean all

# ── Claude Code (via npm) ────────────────────────────────────────────
RUN npm install -g @anthropic-ai/claude-code

# ── User setup ───────────────────────────────────────────────────────
RUN useradd -m -s /bin/bash -G wheel jpk2 \
    && echo 'jpk2 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/jpk2

# ── Tailscale socket for CLI commands ─────────────────────────────────
ENV TS_SOCKET=/var/run/tailscale/tailscaled.sock

# ── Entrypoint ───────────────────────────────────────────────────────
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY tailscale-up.sh /usr/local/bin/tailscale-up.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/tailscale-up.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
