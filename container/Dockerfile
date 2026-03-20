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
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --chmod=755 tailscale-up.sh /usr/local/bin/tailscale-up.sh

# ── Run as jpk2 ──────────────────────────────────────────────────────
USER jpk2
WORKDIR /home/jpk2

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
