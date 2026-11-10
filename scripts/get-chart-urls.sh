#!/bin/bash
cd /tmp
head -c 300 kps.tgz; echo; echo '---'
head -c 300 loki.tgz; echo; echo '---'
grep -oE 'https://[^" ]*kube-prometheus-stack-93\.1\.1\.tgz' /tmp/pc-index.yaml | head -2
grep -oE 'https://[^" ]*loki-7\.5\.0\.tgz' /tmp/grafana-index.yaml | head -2
