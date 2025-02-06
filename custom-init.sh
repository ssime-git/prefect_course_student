#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Fix permissions for the config directory
log "Setting up permissions"
chown -R abc:abc /config
chmod -R 755 /config

# Update package list and install essential dependencies
log "Installing dependencies"
apt-get update && apt-get install -y \
    git \
    curl \
    build-essential

# Get docker GID from the mounted socket and add abc user to it
log "Setting up Docker access"
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
groupadd -g ${DOCKER_GID} docker || true
usermod -aG docker abc

# Note: The user needs to run these commands manually after accessing code-server:
cat > /config/workspace/setup_env.sh << 'EOF'
#!/bin/bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
cd /config/workspace
uv venv
source .venv/bin/activate
uv sync
EOF

chmod +x /config/workspace/setup_env.sh
chown abc:abc /config/workspace/setup_env.sh

log "Setup complete! Please run ./setup_env.sh once you access code-server"