# Security

## Tailscale-Only Access
All cluster access must go through Tailscale. The Kubernetes API server is not exposed publicly. Use:
- `kubectl --kubeconfig ~/.kube/k3s-boxes.yaml` from a Tailscale-connected device
- Grafana via port-forward: `http://localhost:3000` (only accessible when Tailscale is up and the port-forward service is running)

## Deny-All Sandbox Namespace
The `agents-sandbox` namespace has a `NetworkPolicy` that denies all traffic by default. Only explicitly allowed pods may communicate in this namespace.

## Secrets Handling
- Grafana admin password: stored in `~/.k3s-cluster/grafana-pass`, never committed to the repo
- kubeconfig: never committed to the repo. Use placeholders: `<CONTROL_PLANE_IP>`, `<NODE_IP>`
- Tailscale auth key: stored separately, never in the repo
- All YAML manifests use placeholders for IPs and tokens

## kubeconfig Risk
The `~/.kube/k3s-boxes.yaml` file contains the cluster context and token. This file:
- Is NOT tracked in the git repo (covered by .gitignore)
- Must not be copied, moved, or shared
- Should be rotated if exposed
- The `KUBECONFIG` environment variable should be set before running any kubectl commands
