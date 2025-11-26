# Simple Hashtopolis Agent with CUDA support
FROM vastai/base-image:cuda-13.0.1-auto
MAINTAINER XiongChenYu <xiongchenyu6@gmail.com>

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV HASHTOPOLIS_URL=https://hashtopolis.xiongchenyu.dpdns.org
ENV API_ENDPOINT=/api/server.php
ENV VOUCHER=pIdqnsGLe

# Install minimal dependencies - Python 3 and tools to download/unzip
# Also install Python packages via apt to avoid PEP 668 issues
RUN apt-get update && apt-get install -y \
    python3 \
    python3-requests \
    python3-psutil \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /opt/hashtopolis-agent

# Download and extract hashtopolis agent
RUN curl -o a.zip "${HASHTOPOLIS_URL}/agents.php?download=1" && \
    unzip a.zip -d . && \
    rm a.zip

# Simple entrypoint script
RUN echo '#!/bin/bash\n\
echo "========================================="\n\
echo "Hashtopolis Agent Starting"\n\
echo "========================================="\n\
echo "Server: ${HASHTOPOLIS_URL}${API_ENDPOINT}"\n\
echo "Voucher: ${VOUCHER}"\n\
echo "========================================="\n\
\n\
# Start the agent\n\
cd /opt/hashtopolis-agent\n\
python3 __main__.py --url "${HASHTOPOLIS_URL}${API_ENDPOINT}" --voucher "${VOUCHER}"\n\
' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
