# Hashtopolis Agent CUDA Docker Image

This Docker image provides a Hashtopolis distributed cracking agent with CUDA support and Python 3.13.

## Features

- **NVIDIA CUDA 13.0.2 with cuDNN** - Optimized for RTX 50 series and latest NVIDIA GPUs
- **Hashtopolis Agent** - Pre-configured distributed cracking agent
- **Python 3.13.1** - Built from source for optimal compatibility
- **Ubuntu 24.04 LTS** - Latest Ubuntu for stability and security
- **Multi-stage Build** - Optimized image size with only runtime dependencies

## Prerequisites

- Docker installed with NVIDIA Container Toolkit
- NVIDIA GPU with CUDA support
- Access to a Hashtopolis server

## Building the Image

```bash
cd ubuntu-hashcat-cuda
docker build -t xiongchenyu6/hashtopolis-agent-cuda .
```

## Running the Container

### Basic Usage (with default settings)

```bash
docker run -it --gpus all xiongchenyu6/hashtopolis-agent-cuda
```

### With Custom Voucher

```bash
docker run -it --gpus all \
  -e VOUCHER=yourVoucherCode \
  xiongchenyu6/hashtopolis-agent-cuda
```

### With Custom Hashtopolis Server

```bash
docker run -it --gpus all \
  -e HASHTOPOLIS_URL=https://your.server.com \
  -e VOUCHER=yourVoucherCode \
  xiongchenyu6/hashtopolis-agent-cuda
```

### Interactive Shell

```bash
docker run -it --gpus all xiongchenyu6/hashtopolis-agent-cuda bash
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `HASHTOPOLIS_URL` | `https://hashtopolis.xiongchenyu.dpdns.org` | Hashtopolis server URL |
| `API_ENDPOINT` | `/api/server.php` | API endpoint path |
| `VOUCHER` | `pIdqnsGLe` | Agent registration voucher |

## Docker Compose Example

```yaml
version: '3.8'

services:
  hashtopolis-agent:
    image: xiongchenyu6/hashtopolis-agent-cuda
    restart: unless-stopped
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - HASHTOPOLIS_URL=https://your.server.com
      - API_ENDPOINT=/api/server.php
      - VOUCHER=yourVoucherCode
    volumes:
      - ./data:/data
```

## Multiple Agents Example

```yaml
version: '3.8'

services:
  agent1:
    image: xiongchenyu6/hashtopolis-agent-cuda
    restart: unless-stopped
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=0
      - HASHTOPOLIS_URL=https://your.server.com
      - VOUCHER=yourVoucherCode1

  agent2:
    image: xiongchenyu6/hashtopolis-agent-cuda
    restart: unless-stopped
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=1
      - HASHTOPOLIS_URL=https://your.server.com
      - VOUCHER=yourVoucherCode2
```

## Troubleshooting

### Check GPU Availability

The container automatically checks for GPU availability on startup. You can also manually check:

```bash
docker run --gpus all xiongchenyu6/hashtopolis-agent-cuda nvidia-smi
```

### View Help

```bash
docker run xiongchenyu6/hashtopolis-agent-cuda --help
```

### Debug Mode

```bash
docker run -it --gpus all xiongchenyu6/hashtopolis-agent-cuda bash
# Then manually run:
cd /opt/hashtopolis-agent
python3 __main__.py --url https://your.server.com/api/server.php --voucher yourVoucher
```

## Performance Tips

1. **Use `--gpus all`** to enable all available GPUs
2. **Mount tmpfs** for temporary files: `-v /dev/shm:/tmp`
3. **Increase shared memory** if needed: `--shm-size=8g`
4. **Use host networking** for better performance: `--network host`

## Security Notes

- Always use HTTPS for Hashtopolis server connections
- Keep your voucher codes secure
- Consider using Docker secrets for sensitive environment variables
- Regularly update the base image for security patches

## How It Works

The Hashtopolis agent will:
1. Connect to your Hashtopolis server using the provided URL and voucher
2. Download necessary hashcat binaries and configurations from the server
3. Receive cracking tasks from the server
4. Utilize GPU resources to process tasks
5. Report results back to the server

## License

This Docker image includes:
- Hashtopolis Agent (GPL)
- Python 3.13 (PSF License)
- NVIDIA CUDA Runtime (NVIDIA License)