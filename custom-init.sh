#!/bin/bash

# Function to wait for command and proper setup
wait_for_command() {
    local cmd=$1
    local timeout=$2
    local start_time=$(date +%s)
    
    echo "Waiting for $cmd to be available..."
    while ! su abc -c "command -v $cmd" &> /dev/null; do
        current_time=$(date +%s)
        if [ $((current_time - start_time)) -ge $timeout ]; then
            echo "Timeout waiting for $cmd"
            return 1
        fi
        sleep 1
    done
    echo "$cmd is now available"
    return 0
}

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

# Create necessary directories
log "Setting up uv installation"
mkdir -p /config/.local/bin
chown -R abc:abc /config/.local

# Install uv for abc user
log "Installing uv"
su abc -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'
echo 'export PATH="/config/.local/bin:$PATH"' >> /config/.bashrc
echo 'source $HOME/.local/bin/env' >> /config/.bashrc

# Wait for uv to be available
wait_for_command "uv" 30

# Configure git
log "Configuring git"
su abc -c "git config --global init.defaultBranch main"
su abc -c "git config --global core.editor 'code --wait'"

# Setup Python environment
log "Setting up Python environment"
su abc -c "cd /config/workspace && \
    source /config/.bashrc && \
    uv venv && \
    . .venv/bin/activate && \
    [ -f pyproject.toml ] && uv pip install -e . || uv pip install prefect"

# Create helper script for Prefect
log "Creating Prefect helper script"
cat > /config/workspace/start_prefect.sh << 'EOF'
#!/bin/bash
cd /config/workspace
source .venv/bin/activate
export PREFECT_API_URL=http://0.0.0.0:4200/api
prefect server start --host 0.0.0.0 --port 4200
EOF

chmod +x /config/workspace/start_prefect.sh
chown abc:abc /config/workspace/start_prefect.sh

log "Setup complete!"