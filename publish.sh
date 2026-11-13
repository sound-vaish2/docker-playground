#!/bin/bash
# Build a multi-arch image (Intel/AMD + Apple Silicon/ARM) and push it to Docker Hub.
# Usage: ./publish.sh <dockerhub-user> [version]
set -euo pipefail

USER_NAME="${1:?usage: ./publish.sh <dockerhub-user> [version]}"
VERSION="${2:-latest}"
IMAGE="$USER_NAME/docker-playground"

docker login

docker buildx inspect playground-builder >/dev/null 2>&1 || \
  docker buildx create --name playground-builder --use
docker buildx use playground-builder

TAGS=(-t "$IMAGE:$VERSION")
[ "$VERSION" != "latest" ] && TAGS+=(-t "$IMAGE:latest")

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  "${TAGS[@]}" \
  --push .

echo "Published: $IMAGE:$VERSION"
