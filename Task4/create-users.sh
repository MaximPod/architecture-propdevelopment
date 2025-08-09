#!/bin/bash

# Директория для файлов пользователей
mkdir -p user-certs

# Создание пользователя SuperAdmin1
openssl genrsa -out user-certs/SuperAdmin1.key 2048
openssl req -new -key user-certs/SuperAdmin1.key -out user-certs/SuperAdmin1.csr -subj "/CN=SuperAdmin1"
openssl x509 -req -in user-certs/SuperAdmin1.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out user-certs/SuperAdmin1.crt -days 500

kubectl config set-credentials SuperAdmin1 \
  --client-certificate=user-certs/SuperAdmin1.crt \
  --client-key=user-certs/SuperAdmin1.key

kubectl config set-context SuperAdmin1-context \
  --cluster=minikube \
  --user=SuperAdmin1

# Создание пользователя SecurityAuditor1
openssl genrsa -out user-certs/SecurityAuditor1.key 2048
openssl req -new -key user-certs/SecurityAuditor1.key -out user-certs/SecurityAuditor1.csr -subj "/CN=SecurityAuditor1"
openssl x509 -req -in user-certs/SecurityAuditor1.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out user-certs/SecurityAuditor1.crt -days 500

kubectl config set-credentials SecurityAuditor1 \
  --client-certificate=user-certs/SecurityAuditor1.crt \
  --client-key=user-certs/SecurityAuditor1.key

kubectl config set-context SecurityAuditor1-context \
  --cluster=minikube \
  --user=SecurityAuditor1

echo "Users SuperAdmin1 and SecurityAuditor1 created. Kubeconfig contexts configured."
