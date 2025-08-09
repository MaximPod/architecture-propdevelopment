#!/bin/bash

# Привязка SuperAdmin1 к ClusterAdmin
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: superadmin1-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ClusterAdmin
subjects:
- kind: User
  name: SuperAdmin1
  apiGroup: rbac.authorization.k8s.io
EOF

# Привязка SecurityAuditor1 к SecurityAuditor
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: securityauditor1-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: SecurityAuditor
subjects:
- kind: User
  name: SecurityAuditor1
  apiGroup: rbac.authorization.k8s.io
EOF
