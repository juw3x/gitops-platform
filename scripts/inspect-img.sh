#!/bin/bash
docker exec gitops-control-plane crictl inspecti docker.io/library/nginx:1.27-alpine > /tmp/inspecti.json
python3 - <<'EOF'
import json
d = json.load(open('/tmp/inspecti.json'))
st = d.get('status', {})
print('repoTags:', st.get('repoTags'))
print('repoDigests:', st.get('repoDigests'))
print('digest:', d.get('info', {}).get('digest') or st.get('digest'))
EOF
echo '--- pod imageStatus ---'
kubectl -n demo-dev get pod -l app=demo-app -o jsonpath='{.items[0].status.containerStatuses[0].imageID} {.items[0].status.containerStatuses[0].state}'
echo
