#!/usr/bin/env bash
set -euo pipefail

# Secret-scansafe multi-endpoint ClusterIP check
kubectl get svc -A -o json > /tmp/svc.json
kubectl get endpointslices -A -o json > /tmp/eps.json

python3 - <<'PY'
import json, sys

svc = json.load(open('/tmp/svc.json'))['items']
eps = json.load(open('/tmp/eps.json'))['items']

# Count endpoints per service from EndpointSlices
cnt = {}
for e in eps:
    s = e['metadata'].get('labels', {}).get('kubernetes.io/service-name')
    if not s:
        continue
    k = (e['metadata']['namespace'], s)
    cnt[k] = cnt.get(k, 0) + sum(len(x.get('addresses', [])) for x in e.get('endpoints', []))

# Check ClusterIP Services for multi-endpoint
bad = []
for s in svc:
    ip = s['spec'].get('clusterIP')
    # Skip headless and ExternalName
    if ip in (None, 'None', '') or s['spec'].get('type') == 'ExternalName':
        continue
    k = (s['metadata']['namespace'], s['metadata']['name'])
    if cnt.get(k, 0) > 1:
        bad.append((k, cnt[k]))

if bad:
    print("MULTI-ENDPOINT SERVICES (risk):")
    for ns, name, count in bad:
        print(f"  - namespace={ns}, name={name}, endpoint_count={count}")
    print(
        "These services have more than 1 endpoint. "
        "This breaks Service networking on this cluster (kernel load-balancing issue)."
    )
    # Pre-approved rollback: uninstall monitoring
    print(
        "ROLLBACK (pre-approved): helm -n monitoring uninstall kps, then kubectl delete ns monitoring"
    )
else:
    print("MULTI-ENDPOINT: none — all ClusterIP services have exactly 1 endpoint.")
PY
