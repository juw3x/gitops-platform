#!/bin/bash
docker exec gitops-control-plane ctr --namespace=k8s.io images ls -q | grep -i nginx
echo '---'
docker exec gitops-control-plane crictl images | grep nginx
