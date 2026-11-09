# K3s AI-Agent Platform Architecture

## K3s AI-agent platform architecture: control plane, role-based worker pools, Tailscale mesh and observability

![K3s AI-agent platform architecture: control plane, role-based worker pools, Tailscale mesh and observability](assets/architecture/architecture.png)

*Control plane on box2, 9 workers (box3-10), Tailscale mesh, role-based node pools, observability on box6.*

## Overview
A 10-node k3s cluster over Tailscale (private WireGuard mesh) for running AI agents with Prometheus/Grafana observability. The control plane runs on a single node (box2) with workers box3-10. Networking uses flannel CNI over Tailscale.

## Node Roles and Layout

| Node | Role | Labels | Workloads |
|------|------|--------|-----------|
| box2 | control-plane | `role=general,node-role.kubernetes.io/control-plane=`` | kube-apiserver, kube-scheduler, kube-controller-manager, etcd |
| box3 | worker | `role=general` | General agent workloads |
| box4 | worker | `role=general` | General agent workloads |
| box5 | memory (Qdrant planned) | `role=memory` | Qdrant vector store |
| box6 | observability | `role=observability` | Prometheus, Grafana, kube-state-metrics, operator |
| box7 | browser (planned) | `role=browser` | Browser-rendered agents |
| box8 | sandbox (deny-all) | `role=sandbox` | NetworkPolicy deny-all namespace |
| box9 | sandbox (planned) | `role=sandbox` | Sandboxed workloads |
| box10 | worker | `role=general` | General agent workloads |

## Key Design Decisions

### Single Control Plane
The k3s cluster was reduced from 3 servers to 1 (box2) because the provider kernel lacks random load balancing, which breaks multi-endpoint ClusterIP Services. This is a trade-off: HA was given up so that Services work correctly.

### Tailscale Networking
All boxes and the laptop are on Tailscale (private WireGuard mesh). Pod network is flannel over Tailscale.

### Service Constraint
No ClusterIP Service may have 2+ endpoints. Use `replicas: 1` or headless Services (`ClusterIP: None`). This is the primary networking constraint.

### DNS Workloads needing internet
Pods requiring internet access must set `dnsPolicy: None` with custom DNS servers `8.8.8.8` and `1.1.1.1`.

### Storage Constraint
Small 16 GB disks on all nodes. Weekly `crictl rmi --prune` recommended to avoid filling the disk.

### Observability Stack
- Node-exporter on every node
- Prometheus + Grafana on box6 (`role=observability`)
- 3-day retention, 5 GB cap
- Grafana accessed via port-forward from laptop (Tailscale required)

## Node Roles and Layout

| Node | Role | Labels | Workloads |
|------|------|--------|-----------|
| box2 | control-plane | `role=general,node-role.kubernetes.io/control-plane=`` | kube-apiserver, kube-scheduler, kube-controller-manager, etcd |
| box3 | worker | `role=general` | General agent workloads |
| box4 | worker | `role=general` | General agent workloads |
| box5 | memory (Qdrant planned) | `role=memory` | Qdrant vector store |
| box6 | observability | `role=observability` | Prometheus, Grafana, kube-state-metrics, operator |
| box7 | browser (planned) | `role=browser` | Browser-rendered agents |
| box8 | sandbox (deny-all) | `role=sandbox` | NetworkPolicy deny-all namespace |
| box9 | sandbox (planned) | `role=sandbox` | Sandboxed workloads |
| box10 | worker | `role=general` | General agent workloads |

## Diagram

*(Architecture diagram embedded above)*

## Known Constraints
- No ClusterIP Service with 2+ endpoints (use replicas: 1 or headless)
- Pods needing internet must set dnsPolicy: None with 8.8.8.8 and 1.1.1.1
- Small 16 GB disks with weekly image prune
- No S3 (backups on laptop)
SECEOF
