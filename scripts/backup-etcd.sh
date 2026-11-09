#!/usr/bin/env bash
set -euo pipefail

TIMESTAMP=$(date +%F-%H%M)
BOX2="box2"

echo "Saving etcd snapshot from $BOX2..."
ssh $BOX2 'sudo k3s etcd-snapshot save --name pre-single-$TIMESTAMP'

echo "Copying snapshot to local backup directory..."
mkdir -p ~/k3s-backups
scp $BOX2:/var/lib/rancher/k3s/server/db/snapshots/pre-single-$TIMESTAMP.tgz ~/k3s-backups/pre-single-$TIMESTAMP.tgz

echo "Snapshot saved to ~/k3s-backups/pre-single-$TIMESTAMP.tgz"
