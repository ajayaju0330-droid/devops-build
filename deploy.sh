#!/bin/bash
set -e

IMAGE_NAME=${1:-ajayrag/dev}
TAG=${2:-latest}
CONTAINER_NAME=devops-build-app

echo "Pulling $IMAGE_NAME:$TAG ..."
docker pull "$IMAGE_NAME:$TAG"

echo "Removing old container if it exists ..."
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

echo "Starting new container on port 80 ..."
docker run -d --name "$CONTAINER_NAME" -p 80:80 --restart always "$IMAGE_NAME:$TAG"
echo "Deployment complete."
