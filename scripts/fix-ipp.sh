#!/bin/bash
set -e
for r in $(kubectl -n argocd get deploy,sts -o name); do
  kubectl -n argocd patch "$r" --type=json \
    -p='[{"op":"replace","path":"/spec/template/spec/containers/0/imagePullPolicy","value":"IfNotPresent"}]'
done
kubectl -n argocd rollout status deploy/argocd-repo-server --timeout=120s || true
kubectl -n argocd rollout status deploy/argocd-server --timeout=120s || true
kubectl -n argocd rollout status deploy/argocd-dex-server --timeout=120s || true
kubectl -n argocd rollout status deploy/argocd-redis --timeout=120s || true
kubectl -n argocd get pods
