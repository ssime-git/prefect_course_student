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
groupadd -g ${DOCKER_GID} docker || true  # 'true' prevents error if group exists
usermod -aG docker abc

# Install uv (now as user abc to avoid permission issues)
curl -LsSf https://astral.sh/uv/install.sh | su abc -c "sh"

# Add uv to PATH for all users
echo 'export PATH="/config/.cargo/bin:$PATH"' >> /etc/bash.bashrc

# Configure git (as user abc)
su abc -c "git config --global init.defaultBranch main"
su abc -c "git config --global core.editor 'code --wait'"

# Create a venv and install Python using uv (as user abc)
su abc -c "cd /config/workspace && uv venv"