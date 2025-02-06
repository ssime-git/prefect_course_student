#!/bin/bash

# Fix permissions for the config directory
chown -R abc:abc /config
chmod -R 755 /config

# Update package list and install essential dependencies
apt-get update
apt-get install -y \
    git \
    curl \
    build-essential

# Get docker GID from the mounted socket and add abc user to it
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
groupadd -g ${DOCKER_GID} docker || true
usermod -aG docker abc

# Create necessary directories
mkdir -p /config/.cargo
chown -R abc:abc /config/.cargo

# Install uv with better error handling
curl -LsSf https://astral.sh/uv/install.sh > /tmp/install_uv.sh
chmod +x /tmp/install_uv.sh
su abc -c "bash /tmp/install_uv.sh"

# Add uv to PATH for all users (modified to use the correct path)
echo 'export PATH="/config/.cargo/bin:$PATH"' >> /etc/bash.bashrc
echo 'export PATH="/config/.cargo/bin:$PATH"' >> /config/.bashrc

# Configure git (as user abc)
su abc -c "git config --global init.defaultBranch main"
su abc -c "git config --global core.editor 'code --wait'"

# Create a venv and install Python using uv (as user abc)
su abc -c "cd /config/workspace && uv venv && . .venv/bin/activate && uv pip install --system prefect"