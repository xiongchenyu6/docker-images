#!/usr/bin/env bash

echo "Pushing images..."

# Image name and date tag (same as build script)
IMAGE_NAME="xiongchenyu6/ubuntu-hashtopolis-agent-cuda"
DATE_TAG="cuda13.0-$(date +%Y%m%d)"

# Push all tags
echo "1. Pushing ${DATE_TAG}..."
docker push ${IMAGE_NAME}:${DATE_TAG}

echo "2. Pushing cuda13.0..."
docker push ${IMAGE_NAME}:cuda13.0

echo "3. Pushing latest..."
docker push ${IMAGE_NAME}:latest

echo ""
echo "=========================================
Push completed!

Your images are now available at:
- docker.io/${IMAGE_NAME}:${DATE_TAG}
- docker.io/${IMAGE_NAME}:cuda13.0
- docker.io/${IMAGE_NAME}:latest

To pull and run:
  docker pull ${IMAGE_NAME}:latest
  docker run -it --gpus all -e VOUCHER=yourVoucher ${IMAGE_NAME}:latest
========================================="
