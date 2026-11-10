#!/bin/bash
kubectl -n monitoring get pod monitoring-grafana-bc6dff9f8-wffrt -o json | python3 -c '
import json,sys
p=json.load(sys.stdin)
for c in p["spec"].get("initContainers",[])+p["spec"]["containers"]:
    print(c["name"], c["image"])
'
kubectl -n monitoring get events --sort-by=.lastTimestamp | tail -8
