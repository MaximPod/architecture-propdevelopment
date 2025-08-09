#!/bin/bash

# Создание пространств имен (доменов)
kubectl create namespace sales
kubectl create namespace housing
kubectl create namespace finance
kubectl create namespace data

# ClusterRole: ClusterAdmin
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ClusterAdmin
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
- nonResourceURLs: ["*"]
  verbs: ["*"]
EOF

# ClusterRoleBinding для ClusterAdmin (группа: senior-devops-architects)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ClusterAdmin
subjects:
- kind: Group
  name: "senior-devops-architects"
EOF

# ClusterRole: DomainAdmin
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: DomainAdmin
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["roles", "rolebindings"]
  verbs: ["*"]
EOF

# ClusterRole: Developer
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: Developer
rules:
- apiGroups: ["", "apps", "batch"]
  resources: ["pods", "services", "deployments", "configmaps"]
  verbs: ["create", "update", "delete", "get", "list", "watch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list", "watch"]
EOF

# ClusterRole: Viewer
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: Viewer
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
EOF

# ClusterRole: SecurityAuditor
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: SecurityAuditor
rules:
- apiGroups: [""]
  resources: ["secrets", "events"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
EOF

# ClusterRoleBinding для SecurityAuditor (группа: security-specialists)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: security-auditor-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: SecurityAuditor
subjects:
- kind: Group
  name: "security-specialists"
EOF

# Привязка ролей к доменам (для каждого namespace)
namespaces=("sales" "housing" "finance" "data")
for ns in "\${namespaces[@]}"; do
  # DomainAdmin binding
  cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: domain-admin-binding
  namespace: $ns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: DomainAdmin
subjects:
- kind: Group
  name: "devops-$ns"
EOF

  # Developer binding
  cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: $ns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: Developer
subjects:
- kind: Group
  name: "developers-$ns"
EOF

  # Viewer binding
  cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: viewer-binding
  namespace: $ns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: Viewer
subjects:
- kind: Group
  name: "viewers-$ns"
EOF
done