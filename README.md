# gitops-platform

Мини-платформа: kind-кластер `gitops` + Argo CD v3.6.1, приложение деплоится из Git через Kustomize overlays (dev/prod).

## Структура

- `apps/demo-app/base` — базовые манифесты (Deployment nginx + Service)
- `apps/demo-app/overlays/dev` — dev: 2 реплики, nginx:1.27-alpine, ns `demo-dev`
- `apps/demo-app/overlays/prod` — prod: 2 реплики, nginx:1.29-alpine, ns `demo-prod`
- `argocd/` — Application-манифесты для Argo CD
- `scripts/` — вспомогательные скрипты

## Доступы

- Argo CD UI: https://localhost:8081 (self-signed), логин `admin`, пароль — в секрете:
  `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d`
- Git-репозиторий: `git://172.24.0.1:9418/gitops-platform` (git daemon, 172.24.0.1 — gateway kind-сети)

## Запуск (в WSL Ubuntu)

```bash
kind create cluster --name gitops
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# git-сервер для репозитория ( setsid — чтобы не умер вместе с shell )
setsid nohup git daemon --export-all --base-path=$HOME --listen=0.0.0.0 --port=9418 --reuseaddr > ~/git-daemon.log 2>&1 < /dev/null &

# port-forward к Argo CD UI
setsid nohup kubectl -n argocd port-forward svc/argocd-server 8081:443 >/tmp/pf.log 2>&1 < /dev/null &

kubectl apply -f argocd/app-dev.yaml -f argocd/app-prod.yaml
kubectl -n argocd get applications   # Synced / Healthy
kubectl get pods -n demo-dev -n demo-prod
```

## GitOps-демо

Изменить `replicas` или `newTag` в overlay → `git commit` → Argo CD (auto-sync + selfHeal)
подхватит изменение при следующем опросе (~3 мин) или сразу по
`kubectl -n argocd annotate app <name> argocd.argoproj.io/refresh=normal --overwrite`.

Уже проверено: коммит `scale dev to 2 replicas` → deployment в demo-dev масштабировался автоматически.

## Примечания

- `argocd-dex-server` может быть в ImagePullBackOff (ghcr.io недоступен) — это SSO-компонент, на GitOps не влияет.
- Образы nginx загружены в kind-ноду через `ctr import` (docker.io был недоступен); в нормальной сети тянутся сами.
