#!/usr/bin/env bash
set -euo pipefail

for n in box2 box3 box4 box5 box6 box7 box8 box9 box10; do
  echo "=== Pruning images on $n ==="
  ssh $n 'crictl rmi --prune --all'
done
