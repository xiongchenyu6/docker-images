#!/usr/bin/env bash

# Build script for VastAI Hashtopolis Agent CUDA Docker image

echo "Building VastAI Hashtopolis Agent CUDA Docker image..."
echo "========================================="

# Build the Docker image
docker build -t xiongchenyu6/vastai-hashtopolis-agent-cuda:latest .

# Tag with additional tags for push
if [ $? -eq 0 ]; then
    docker tag xiongchenyu6/vastai-hashtopolis-agent-cuda:latest xiongchenyu6/vastai-hashtopolis-agent-cuda:cuda13.0
    docker tag xiongchenyu6/vastai-hashtopolis-agent-cuda:latest xiongchenyu6/vastai-hashtopolis-agent-cuda:cuda13.0-20241126
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "Build completed successfully!"
    echo ""
    echo "To test the image, run:"
    echo "  docker run --rm xiongchenyu6/vastai-hashtopolis-agent-cuda:latest python3 --version"
    echo "  docker run --rm --gpus all xiongchenyu6/vastai-hashtopolis-agent-cuda:latest nvidia-smi"
    echo ""
    echo "To run the hashtopolis agent:"
    echo "  docker run -it --gpus all xiongchenyu6/vastai-hashtopolis-agent-cuda:latest"
    echo ""
    echo "To run with custom voucher:"
    echo "  docker run -it --gpus all -e VOUCHER=yourVoucher xiongchenyu6/vastai-hashtopolis-agent-cuda:latest"
else
    echo ""
    echo "Build failed! Please check the error messages above."
    exit 1
fi