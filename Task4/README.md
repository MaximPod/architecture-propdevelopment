## Порядок запуска скриптов:
./create-roles.sh
./create-users.sh
./create-user-bindings.sh

## Проверка созданных ресурсов
kubectl get clusterroles
kubectl get clusterrolebindings
kubectl get rolebindings -A

## Скрипт create-roles.sh:
Создает 4 namespace (домена): sales, housing, finance, data.
Определяет 5 ClusterRoles с нужными правами.
Создает RoleBindings для доменных ролей (DomainAdmin, Developer, Viewer) в каждом namespace.
Использует группы пользователей (например, devops-sales), которые должны быть настроены в системе аутентификации.

## Скрипт create-users.sh:
Использует minikube CA для подписи сертификатов.
Создает ключи и сертификаты для SuperAdmin1 и SecurityAuditor1.
Настраивает контексты в kubeconfig.

## Скрипт create-user-bindings.sh:
Связывает конкретных пользователей с глобальными ролями через ClusterRoleBinding.
Пользователь SuperAdmin1 получает полный доступ к кластеру, 
Пользователь SecurityAuditor1 — права на аудит. 
