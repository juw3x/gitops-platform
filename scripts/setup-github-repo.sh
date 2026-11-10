#!/bin/bash
set -e
# Argo CD repository secret for SSH access to GitHub
kubectl -n argocd create secret generic repo-juw3x-gitops-platform \
  --from-literal=type=git \
  --from-literal=url=git@github.com:juw3x/gitops-platform.git \
  --from-file=sshPrivateKey=$HOME/.ssh/argocd-github \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl -n argocd label secret repo-juw3x-gitops-platform argocd.argoproj.io/secret-type=repository --overwrite
kubectl -n argocd get secret repo-juw3x-gitops-platform -o yaml | grep -E 'url:|type:' | head -4
