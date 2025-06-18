# GPU Metrics Agent

A high-performance agent for collecting NVIDIA GPU metrics and exporting them via OpenTelemetry Arrow protocol. Developed by [Daniel Tefera Birhanu](https://github.com/danieltefera08) for comprehensive GPU observability.

## Why GPU Metrics Agent?

Modern GPU workloads require deep visibility into resource utilization, performance characteristics, and system behavior. This agent provides the metrics you need to optimize GPU usage, reduce costs, and troubleshoot performance issues.

## Use Cases

### 🎯 GPU Resource Optimization
Track GPU and memory utilization to identify underutilized resources. Optimize batch sizes and workload scheduling based on actual GPU usage patterns.

**Key metrics**: `gpu_utilization_percent`, `gpu_utilization_memory_percent`

### 👥 Multi-tenant GPU Sharing
Monitor per-process GPU utilization to ensure fair resource allocation in shared environments. Track which processes are consuming GPU resources and enforce usage policies.

**Key metrics**: Per-process `gpu_utilization_percent` with `pid` and `comm` attributes

### 🔍 Performance Troubleshooting
Identify performance bottlenecks by correlating GPU metrics with application behavior. Detect thermal throttling, power limitations, and PCIe bandwidth constraints.

**Key metrics**: `gpu_temperature_celsius`, `gpu_clock_hertz`, `gpu_pcie_throughput_*_bytes`

### 💰 Cost Management
Monitor power consumption to calculate operational costs and optimize for efficiency. Track power usage trends and identify opportunities for cost reduction.

**Key metrics**: `gpu_power_watt`, `gpu_power_limit_watt`

### 📊 Capacity Planning
Analyze historical utilization patterns to plan for future GPU infrastructure needs. Understand peak usage times and resource requirements for different workloads.

**Key metrics**: All utilization metrics with time-series analysis

### 🤖 ML/AI Workload Monitoring
Track GPU performance during model training and inference. Ensure optimal resource allocation for different phases of machine learning pipelines.

**Key metrics**: All metrics combined with workload-specific context

## Collected Metrics

| Metric | Description | Collection Interval |
|--------|-------------|-------------------|
| `gpu_utilization_percent` | GPU compute utilization (0-100%) | 5s |
| `gpu_utilization_memory_percent` | GPU memory utilization (0-100%) | 5s |
| `gpu_power_watt` | Current power consumption | 1s |
| `gpu_power_limit_watt` | Maximum power limit | 1s |
| `gpu_clock_hertz` | Clock speeds (graphics, SM, memory, video) | 1s |
| `gpu_temperature_celsius` | GPU temperature | 1s |
| `gpu_pcie_throughput_transmit_bytes` | PCIe transmit throughput | 100ms |
| `gpu_pcie_throughput_receive_bytes` | PCIe receive throughput | 100ms |

All metrics include `uuid` (GPU identifier) and `index` (GPU index) attributes. Process-level metrics also include `pid` and `comm` attributes.

## Quick Start

### Installation

For Kubernetes deployments, see our [comprehensive setup guide](https://github.com/danieltefera08/docs/setup-collection-kubernetes-gpu).

### Basic Usage

```bash
./wisp \
  --remote-store-address=grpc.danieltefera08.com:443 \
  --metrics-producer-nvidia-gpu=true \
  --node=$(hostname) \
  --log-level=info
```

### Docker

```bash
docker run -it --rm \
  --gpus all \
  -v /etc/machine-id:/etc/machine-id:ro \
  -v /var/run/secrets/danieltefera08.com:/var/run/secrets/danieltefera08.com:ro \
  ghcr.io/danieltefera08/wisp:latest \
  --remote-store-address=grpc.danieltefera08.com:443 \
  --metrics-producer-nvidia-gpu=true
```

### Configuration Options

| Flag | Description | Default |
|------|-------------|---------|
| `--remote-store-address` | gRPC endpoint for metric storage | Required |
| `--metrics-producer-nvidia-gpu` | Enable NVIDIA GPU metrics | false |
| `--collection-interval` | Metric export interval | 10s |
| `--node` | Node name for metric labeling | Machine ID |
| `--bearer-token` | Authentication token | - |

## Architecture

The agent consists of three main components:

1. **NVIDIA Producer**: Interfaces with NVIDIA Management Library (NVML) to collect GPU metrics
2. **Metric Exporter**: Batches and exports metrics using OpenTelemetry Arrow protocol
3. **gRPC Client**: Manages secure connections to remote storage endpoints

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  NVIDIA GPUs    │────▶│  GPU Metrics     │────▶│ Remote Storage  │
│  (via NVML)     │     │  Agent           │     │ (gRPC/OTel)    │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

## Requirements

- NVIDIA GPU with driver version 390.x or newer
- Linux operating system
- NVIDIA Management Library (NVML) available

## Building from Source

```bash
go build ./cmd/wisp
```

## License

Apache License 2.0

## Support

- Documentation: [danieltefera08.com/docs](https://github.com/danieltefera08/docs)
- Issues: [GitHub Issues](https://github.com/danieltefera08/wisp/issues)