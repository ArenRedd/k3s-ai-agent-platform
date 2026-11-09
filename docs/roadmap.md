# Roadmap

## Short-term
- [ ] Deploy Qdrant on box5 (role=memory) with persistent local-path storage
- [ ] Deploy browser-rendered agents on box7 (role=browser) with headless Chromium
- [ ] Add sandbox namespace with NetworkPolicy deny-all (box8, box9)
- [ ] Configure Grafana alerts for disk usage > 80%, node-exporter down, Prometheus query failures

## Medium-term
- [ ] Migrate Hermes from AWS server to box10 for local control
- [ ] Implement 3-server HA control plane (requires kernel-level load-balancing fix)
- [ ] Add S3-compatible storage (MinIO) or ensure weekly pruning remains sufficient
- [ ] Add GitOps workflow with ArgoCD

## Long-term
- [ ] Multi-region cluster extension (box1 in Dallas as edge node, not control plane)
- [ ] Agent sandbox execution with resource quotas per node
- [ ] Automated image pruning and garbage collection scripts
- [ ] Prometheus alerts sent to Telegram/Slack
