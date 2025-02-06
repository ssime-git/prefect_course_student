#!/bin/bash

# Update package list and install essential dependencies
apt-get update
apt-get install -y \
    git \
    curl \
    build-essential

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH
echo 'export PATH="/root/.cargo/bin:$PATH"' >> /etc/bash.bashrc

# Configure git
git config --global init.defaultBranch main
git config --global core.editor "code --wait"

# Create a venv and install Python using uv
# Uncomment if you need it automatically
# su abc -c "uv venv"