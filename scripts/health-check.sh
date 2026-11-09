#!/usr/bin/env bash
set -euo pipefail

echo "=== Node Status ==="
kubectl get nodes -o wide

echo -e "\n=== Non-Running Pods ==="
kubectl get pods -A | grep -v "Running" | grep -v "Completed" | grep -v "NAMESPACE" || echo "All pods running or completed"

echo -e "\n=== Warning Events ==="
kubectl get events -A --sort-by=.metadata.creationTimestamp | grep "Warning" | tail -10

echo -e "\n=== Top Nodes (CPU) ==="
kubectl top nodes --sort-by=cpu | head -5

echo -e "\n=== Disk Usage per Node ==="
for n in box2 box3 box4 box5 box6 box7 box8 box9 box10; do
  echo -n "$n: "
  ssh $n 'df -h / | tail -1'
done
