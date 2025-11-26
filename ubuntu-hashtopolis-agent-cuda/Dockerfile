# Simple Hashtopolis Agent with CUDA support
FROM nvidia/cuda:13.0.2-cudnn-devel-ubuntu24.04
MAINTAINER XiongChenYu <xiongchenyu6@gmail.com>

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV HASHTOPOLIS_URL=https://hashtopolis.xiongchenyu.dpdns.org
ENV API_ENDPOINT=/api/server.php
ENV VOUCHER=pIdqnsGLe

# Set NVIDIA and OpenCL environment variables
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV PATH=/usr/local/cuda/bin:${PATH}

# Install minimal dependencies - Python 3 and tools to download/unzip
# Also install Python packages via apt to avoid PEP 668 issues
# Install OpenCL runtime and lspci for GPU support
RUN apt-get update && apt-get install -y \
    python3 \
    python3-requests \
    python3-psutil \
    curl \
    unzip \
    pciutils \
    ocl-icd-libopencl1 \
    ocl-icd-opencl-dev \
    opencl-headers \
    clinfo \
    && rm -rf /var/lib/apt/lists/*

# Setup multiple NVIDIA OpenCL ICD paths (try different library locations)
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \
    echo "/usr/local/nvidia/lib64/libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia-full.icd && \
    echo "/usr/lib/x86_64-linux-gnu/libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia-lib.icd

# Create symlinks for OpenCL libraries
RUN ldconfig

# Create working directory
WORKDIR /opt/hashtopolis-agent

# Download and extract hashtopolis agent
RUN curl -o a.zip "${HASHTOPOLIS_URL}/agents.php?download=1" && \
    unzip a.zip -d . && \
    rm a.zip

# Enhanced entrypoint script with OpenCL fixes
RUN echo '#!/bin/bash\n\
echo "========================================="\n\
echo "Hashtopolis Agent Starting"\n\
echo "========================================="\n\
echo "Server: ${HASHTOPOLIS_URL}${API_ENDPOINT}"\n\
echo "Voucher: ${VOUCHER}"\n\
echo "========================================="\n\
echo "Checking GPU and OpenCL availability..."\n\
echo "-----------------------------------------"\n\
\n\
# Check NVIDIA driver\n\
echo "NVIDIA Driver Check:"\n\
nvidia-smi 2>/dev/null || echo "nvidia-smi not available"\n\
echo ""\n\
\n\
# Check PCI devices (GPUs)\n\
echo "PCI Devices (GPUs):"\n\
lspci | grep -E "VGA|3D|Display" || echo "No GPU devices found via lspci"\n\
echo ""\n\
\n\
# Try to find and link NVIDIA OpenCL libraries\n\
echo "Searching for NVIDIA OpenCL libraries..."\n\
for lib_path in /usr/local/nvidia/lib64 /usr/lib/x86_64-linux-gnu /usr/local/cuda/lib64 /usr/lib64; do\n\
    if [ -f "$lib_path/libnvidia-opencl.so.1" ]; then\n\
        echo "Found OpenCL library at: $lib_path"\n\
        export LD_LIBRARY_PATH="$lib_path:$LD_LIBRARY_PATH"\n\
        # Update ICD file with correct path\n\
        echo "$lib_path/libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia-runtime.icd\n\
    fi\n\
done\n\
echo ""\n\
\n\
# Check OpenCL ICD files\n\
echo "OpenCL ICD Files:"\n\
ls -la /etc/OpenCL/vendors/ 2>/dev/null || echo "No ICD files found"\n\
echo ""\n\
\n\
# Check OpenCL platforms\n\
echo "OpenCL Platforms:"\n\
clinfo -l 2>/dev/null || echo "No OpenCL platforms detected"\n\
echo ""\n\
\n\
# Display environment\n\
echo "Environment Variables:"\n\
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"\n\
echo "PATH: $PATH"\n\
echo "========================================="\n\
\n\
# Start the agent\n\
cd /opt/hashtopolis-agent\n\
python3 __main__.py --url "${HASHTOPOLIS_URL}${API_ENDPOINT}" --voucher "${VOUCHER}"\n\
' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
