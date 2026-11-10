# gitops-platform

Мини-платформа: kind-кластер + Argo CD, приложение деплоится из Git через Kustomize overlays (dev/prod).

## Структура

- `apps/demo-app/base` — базовые манифесты (Deployment nginx + Service)
- `apps/demo-app/overlays/dev` — dev: 1 реплика, nginx:1.27-alpine, ns `demo-dev`
- `apps/demo-app/overlays/prod` — prod: 2 реплики, nginx:1.29-alpine, ns `demo-prod`
- `argocd/` — Application-манифесты для Argo CD

## Запуск

```bash
kind create cluster --name gitops
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

# git-сервер для репозитория (из корня репо):
git daemon --export-all --base-path=$HOME --listen=0.0.0.0 --port=9418 &

kubectl apply -f argocd/app-dev.yaml -f argocd/app-prod.yaml
kubectl -n argocd port-forward svc/argocd-server 8080:443
# UI: https://localhost:8080  (admin / <пароль из секрета>)
```

## GitOps-демо

Изменить `replicas` или `newTag` в overlay, закоммитить и запушить в master —
Argo CD (auto-sync + selfHeal) сам применит изменения в кластер.
