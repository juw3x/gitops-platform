#!/bin/bash
# Pull images on host docker with retries, then import into kind node gitops
IMAGES=(
  "docker.io/library/busybox:1.38.0"
  "quay.io/kiwigrid/k8s-sidecar:2.14.3"
  "docker.io/grafana/grafana:13.3.0-distroless"
)
NODE=gitops-control-plane
for img in "${IMAGES[@]}"; do
  for i in $(seq 1 20); do
    if docker pull "$img" >/dev/null 2>&1; then
      echo "PULLED $img"
      docker save "$img" | docker exec -i "$NODE" ctr --namespace=k8s.io images import --digests - >/dev/null 2>&1 \
        && echo "IMPORTED $img" || echo "IMPORT-FAIL $img"
      break
    else
      echo "retry $i for $img"
      sleep 15
    fi
  done
done
echo DONE
