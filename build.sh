#!/bin/bash
set -e

IMAGE_NAME=${1:-ajayrag/dev}
TAG=${2:-latest}

echo "Building image $IMAGE_NAME:$TAG ..."
docker build -t "$IMAGE_NAME:$TAG" .
echo "Build complete."
