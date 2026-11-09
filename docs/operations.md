# Operations

## Daily Health Check
```bash
./scripts/health-check.sh
```
This checks:
- Node status and Ready condition
- Non-running pods and their warnings
- Top CPU/Memory usage per node
- Disk usage per node

## Backup and Restore
```bash
./scripts/backup-etcd.sh
```
This takes an etcd snapshot on box2 and copies it to ~/k3s-backups/.

To restore:
```bash
# Copy snapshot to box2 and etcd snapshot restore
sudo -S -p '' etcdctl snapshot restore <snapshot-file> \
  --data-dir /var/lib/rancher/k3s/server/db
```

## Disk Cleanup
```bash
./scripts/disk-prune.sh
```
Uses `crictl rmi --prune` per node to remove unused container images.

## Node Maintenance
- To add a new worker: join with `k3s agent --server ... --token ... --node-name boxN --node-ip $(tailscale ip -4)`
- To remove a node: `kubectl delete node boxN` (confirms etcd member removal), then `k3s-uninstall.sh`
- Kernel load-balancing issue: if Services start failing, the cluster was likely expanded beyond 1 control plane

## Service Guard
```bash
./scripts/service-guard.sh
```
Checks that no ClusterIP Service has 2+ endpoints. If found, `helm -n monitoring uninstall kps` is the pre-approved rollback.
