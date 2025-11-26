# OpenCL Troubleshooting Guide for Hashtopolis Agent

## Problem: `CL_PLATFORM_NOT_FOUND_KHR` Error

This error indicates that hashcat cannot find the OpenCL platform for your GPU. Here are comprehensive solutions:

## Quick Fix Attempts

### 1. Ensure Proper Docker/Podman Run Command

**Docker:**
```bash
docker run --rm --gpus all \
  --device /dev/nvidia0 \
  --device /dev/nvidiactl \
  --device /dev/nvidia-modeset \
  xiongchenyu6/ubuntu-hashtopolis-agent-cuda:latest
```

**Podman:**
```bash
podman run --rm \
  --device nvidia.com/gpu=all \
  --security-opt=label=disable \
  xiongchenyu6/ubuntu-hashtopolis-agent-cuda:latest
```

### 2. Try the Alternative Dockerfile

Build and run the alternative version which uses Ubuntu 22.04:

```bash
docker build -f Dockerfile.alternative -t hashtopolis-alt .
docker run --rm --gpus all hashtopolis-alt
```

### 3. Debug the Container

Run the debug script to identify the issue:

```bash
# Copy debug script into running container
docker cp debug-opencl.sh CONTAINER_ID:/debug-opencl.sh

# Execute debug script
docker exec CONTAINER_ID /debug-opencl.sh
```

## Root Causes and Solutions

### Issue 1: NVIDIA Driver Not Properly Mounted

**Solution:** Ensure NVIDIA Container Toolkit is installed:

```bash
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### Issue 2: OpenCL ICD Not Finding NVIDIA Library

**Solution:** Mount the host's NVIDIA libraries:

```bash
docker run --rm --gpus all \
  -v /usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.1:/usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.1:ro \
  xiongchenyu6/ubuntu-hashtopolis-agent-cuda:latest
```

### Issue 3: Wrong CUDA/Driver Version Mismatch

**Solution:** Check your host NVIDIA driver version:

```bash
nvidia-smi --query-gpu=driver_version --format=csv,noheader
```

Then use a matching CUDA base image. For driver 525+, use CUDA 12.x or 13.x.

## Manual Fix Inside Container

If the container is running but OpenCL isn't working:

```bash
# Enter the container
docker exec -it CONTAINER_ID /bin/bash

# Find NVIDIA OpenCL library
find / -name "*nvidia-opencl*" 2>/dev/null

# If found at /path/to/libnvidia-opencl.so.1
echo "/path/to/libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# Test
clinfo -l
```

## Building Custom Image with Host Driver

Create a Dockerfile that uses your host's driver:

```dockerfile
FROM nvidia/cuda:13.0-runtime-ubuntu22.04

# Copy OpenCL library from host during build
COPY --from=host /usr/lib/x86_64-linux-gnu/libnvidia-opencl.so* /usr/local/nvidia/lib64/

# Rest of Dockerfile...
```

## Environment Variables to Try

Add these to your docker run command:

```bash
docker run --rm --gpus all \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e LD_LIBRARY_PATH=/usr/local/nvidia/lib64:/usr/local/cuda/lib64 \
  xiongchenyu6/ubuntu-hashtopolis-agent-cuda:latest
```

## Testing OpenCL Without Hashtopolis

Test if OpenCL works at all:

```bash
docker run --rm --gpus all xiongchenyu6/ubuntu-hashtopolis-agent-cuda:latest clinfo
```

If this shows "Number of platforms: 0", the issue is with OpenCL setup, not hashtopolis.

## Last Resort: Disable OpenCL

If GPU compute works but OpenCL doesn't, you might need to:
1. Use CUDA-only hashcat
2. Or use CPU-only mode (much slower)

## Contact Support

If none of these solutions work:
1. Run the debug script and save output
2. Check `docker logs CONTAINER_ID`
3. Report issue with full debug output

The issue is typically related to:
- NVIDIA Container Toolkit configuration
- Driver/CUDA version mismatch
- Missing OpenCL runtime libraries
- Incorrect library paths in container