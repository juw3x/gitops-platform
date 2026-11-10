#!/bin/bash
for u in public.ecr.aws ghcr.io registry-1.docker.io quay.io cdn01.quay.io github.com raw.githubusercontent.com; do
  out=$(timeout 25 curl -sI "https://$u" -o /dev/null -w '%{http_code} %{time_total}s' || echo FAIL)
  echo "$u -> $out"
done
