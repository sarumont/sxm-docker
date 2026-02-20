#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOCKER_DIR="$SCRIPT_DIR"
PLAYER_DIR="$SCRIPT_DIR/../sxm-player"

if [[ ! -d "$PLAYER_DIR" ]]; then
    echo "ERROR: sxm-player not found at $PLAYER_DIR"
    exit 1
fi

# Update both repos
echo "==> Updating sxm-player..."
git -C "$PLAYER_DIR" pull --ff-only

echo "==> Updating sxm-docker..."
git -C "$DOCKER_DIR" pull --ff-only

# Stop existing container
if docker compose -f "$DOCKER_DIR/docker-compose.yml" ps -q 2>/dev/null | grep -q .; then
    echo "==> Stopping running container..."
    docker compose -f "$DOCKER_DIR/docker-compose.yml" down
fi

# Copy sxm-player source into build context (Docker can't follow symlinks outside context)
echo "==> Copying sxm-player into build context..."
rm -rf "$DOCKER_DIR/sxm-player"
rsync -a --exclude='.git' --exclude='__pycache__' --exclude='*.egg-info' \
    "$PLAYER_DIR/" "$DOCKER_DIR/sxm-player/"

# Build and start
echo "==> Building..."
docker compose -f "$DOCKER_DIR/docker-compose.yml" build --no-cache

echo "==> Starting..."
docker compose -f "$DOCKER_DIR/docker-compose.yml" up -d

# Clean up copied source
rm -rf "$DOCKER_DIR/sxm-player"

echo "==> Done. Tailing logs (Ctrl-C to stop)..."
docker compose -f "$DOCKER_DIR/docker-compose.yml" logs -f
