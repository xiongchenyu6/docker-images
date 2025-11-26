#!/usr/bin/env bash

# Build script for Hashtopolis Agent CUDA Docker image with Python 3.13

echo "Building Hashtopolis Agent CUDA Docker image with Python 3.13..."
echo "========================================="

# Image name and tags
IMAGE_NAME="xiongchenyu6/ubuntu-hashtopolis-agent-cuda"
DATE_TAG="cuda13.0-$(date +%Y%m%d)"

# Build the Docker image
docker build -t ${IMAGE_NAME}:latest .

if [ $? -eq 0 ]; then
    # Tag with additional tags
    docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${DATE_TAG}
    docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:cuda13.0

    echo ""
    echo "========================================="
    echo "Build completed successfully!"
    echo ""
    echo "Created tags:"
    echo "  - ${IMAGE_NAME}:latest"
    echo "  - ${IMAGE_NAME}:cuda13.0"
    echo "  - ${IMAGE_NAME}:${DATE_TAG}"
    echo ""
    echo "To test the image, run:"
    echo "  docker run --rm ${IMAGE_NAME}:latest python3 --version"
    echo "  docker run --rm --gpus all ${IMAGE_NAME}:latest nvidia-smi"
    echo ""
    echo "Or with podman:"
    echo "  podman run --rm --device nvidia.com/gpu=all ${IMAGE_NAME}:latest nvidia-smi"
    echo ""
    echo "To run the hashtopolis agent:"
    echo "  docker run -it --gpus all ${IMAGE_NAME}:latest"
    echo ""
    echo "To run with custom voucher:"
    echo "  docker run -it --gpus all -e VOUCHER=yourVoucher ${IMAGE_NAME}:latest"
else
    echo ""
    echo "Build failed! Please check the error messages above."
    exit 1
fi