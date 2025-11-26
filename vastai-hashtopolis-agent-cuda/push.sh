#!/usr/bin/env bash

# Push script for VastAI Hashtopolis Agent CUDA Docker image

echo "=========================================
Pushing VastAI Hashtopolis Agent CUDA images to Docker Hub
========================================="

echo "Pushing images..."

# Push all tags
echo "1. Pushing cuda13.0-20241126..."
docker push xiongchenyu6/vastai-hashtopolis-agent-cuda:cuda13.0-20241126

echo "2. Pushing cuda13.0..."
docker push xiongchenyu6/vastai-hashtopolis-agent-cuda:cuda13.0

echo "3. Pushing latest..."
docker push xiongchenyu6/vastai-hashtopolis-agent-cuda:latest

echo ""
echo "=========================================
Push completed!

Your images are now available at:
- docker.io/xiongchenyu6/vastai-hashtopolis-agent-cuda:cuda13.0-20241126
- docker.io/xiongchenyu6/vastai-hashtopolis-agent-cuda:cuda13.0
- docker.io/xiongchenyu6/vastai-hashtopolis-agent-cuda:latest

To pull and run:
  docker pull xiongchenyu6/vastai-hashtopolis-agent-cuda:latest
  docker run -it --gpus all -e VOUCHER=yourVoucher xiongchenyu6/vastai-hashtopolis-agent-cuda:latest
========================================="
