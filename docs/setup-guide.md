# Setup Guide

## Prerequisites
- 10 Debian 13 boxes (4 CPU, ~8 GB RAM, 16 GB disk)
- Tailscale installed and running on all boxes and laptop
- k3s installed: single control plane on box2, workers box3-10
- Tailscale mesh: all nodes reachable via `tailscale ip -4`

## Cluster Installation (already completed)
1. box2 initialized as single control plane: `k3s server --tls-san box2`
2. Workers joined: `k3s agent --server https://box2:6443 --token <token> --node-name boxN --node-ip <tailscale-ip>`
3. Networking: flannel CNI over Tailscale
4. Node roles assigned via labels: `kubectl label node boxN role=general/observability/memory`

## Observability Stack Installation
```bash
# Install kube-prometheus-stack from local chart
helm install kps ~/k3s-charts/kube-prometheus-stack-93.1.0.tgz \
  -n monitoring --create-namespace \
  -f monitoring-values.yaml -f monitoring-secret.yaml \
  --wait --timeout 10m
```

## Accessing Grafana
```bash
# Port-forward (systemd user service handles this automatically)
systemctl --user start grafana-forward.service

# Then open http://localhost:3000
# User: admin, Password: from ~/.k3s-cluster/grafana-pass
```

## Accessing Headlamp
```bash
# via Walker launcher (SUPER + SPACE): type "K3s Dashboards"
# Or manually: flatpak run io.kinvolk.Headlamp --ozone-platform=x11
```

## Running the Example Agent Job
```bash
kubectl apply -f manifests/examples/agent-job.yaml
```
This Job uses `nodeSelector: role=general`, `dnsPolicy: None` with `8.8.8.8` and `1.1.1.1`, and resource limits appropriate for 16 GB disks.
