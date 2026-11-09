# Troubleshooting

## Kernel Load-Balancing Issue
**Symptom**: `kubectl get endpoints` shows multiple endpoints for a ClusterIP Service, or Services round-robin incorrectly.

**Root cause**: The provider kernel (Omarchy/Linux) lacks random IP load balancing support. This was confirmed when the 3-server HA setup caused Services to have inconsistent endpoint distribution.

**Fix**: Reduced the control plane from 3 servers to 1 (box2). This is a trade-off: HA was given up so that Services work correctly.

**Workaround**: Use `replicas: 1` for Deployments, or use headless Services (`ClusterIP: None`). Avoid Services with multiple replicas unless you can ensure kernel-level load balancing.

## DNS Workaround
**Symptom**: Pods cannot resolve external domains, or `curl google.com` fails from inside a pod.

**Root cause**: k3s default `dnsPolicy` uses the cluster DNS, which may not forward external queries correctly when running over Tailscale.

**Fix**: Set `dnsPolicy: None` in the Pod spec and configure custom DNS:
```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: my-container
    image: my-image
    dnsPolicy: None
    dns:
      - 8.8.8.8
      - 1.1.1.1
```
