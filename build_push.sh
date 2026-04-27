#!/bin/bash
set -e

IMAGE_NAME="docker.io/katsuhiro10092417/stylebertvits2-runpod-mac"
TAG="v0.1.0"

docker buildx build \
  --platform linux/amd64 \
  -t ${IMAGE_NAME}:${TAG} \
  --push .