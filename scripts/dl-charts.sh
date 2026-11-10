#!/bin/bash
cd /tmp
for i in $(seq 1 15); do
  curl -sL --max-time 60 -o kps.tgz 'https://github.com/prometheus-community/helm-charts/releases/download/kube-prometheus-stack-93.1.1/kube-prometheus-stack-93.1.1.tgz' && tar tzf kps.tgz >/dev/null 2>&1 && break
  echo "kps retry $i"; sleep 10
done
for i in $(seq 1 15); do
  curl -sL --max-time 60 -o loki.tgz 'https://github.com/grafana/helm-charts/releases/download/helm-loki-7.5.0/loki-7.5.0.tgz' && tar tzf loki.tgz >/dev/null 2>&1 && break
  echo "loki retry $i"; sleep 10
done
tar xzf kps.tgz 2>/dev/null; tar xzf loki.tgz 2>/dev/null
echo "kps: $(ls -d kube-prometheus-stack 2>/dev/null) loki: $(ls -d loki 2>/dev/null)"
