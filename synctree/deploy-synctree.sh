#!/bin/bash

# namespace 
kubectl create namespace synctree > /dev/null 2>&1


# config map
kubectl delete configmap deploy-configmap --namespace=synctree > /dev/null 2>&1
kubectl create configmap deploy-configmap --from-file=./deploy --namespace=synctree

# nginx confs
kubectl delete configmap nginx-studio-conf --namespace=synctree > /dev/null 2>&1
kubectl create configmap nginx-studio-conf --from-file=./conf.d/studio.conf --namespace=synctree
kubectl delete configmap nginx-tool-conf --namespace=synctree > /dev/null 2>&1
kubectl create configmap nginx-tool-conf --from-file=./conf.d/tool.conf --namespace=synctree
kubectl delete configmap nginx-tool-proxy-conf --namespace=synctree > /dev/null 2>&1
kubectl create configmap nginx-tool-proxy-conf --from-file=./conf.d/tool-proxy.conf --namespace=synctree
kubectl delete configmap nginx-testing-conf --namespace=synctree > /dev/null 2>&1
kubectl create configmap nginx-testing-conf --from-file=./conf.d/testing.conf --namespace=synctree
kubectl delete configmap nginx-portal-conf --namespace=synctree > /dev/null 2>&1
kubectl create configmap nginx-portal-conf --from-file=./conf.d/portal.conf --namespace=synctree
kubectl delete configmap nginx-portal-admin-conf --namespace=synctree > /dev/null 2>&1
kubectl create configmap nginx-portal-admin-conf --from-file=./conf.d/portal-admin.conf --namespace=synctree
#kubectl delete configmap nginx-batch-conf --namespace=synctree > /dev/null 2>&1
#kubectl create configmap nginx-batch-conf --from-file=./conf.d/batch.conf --namespace=synctree
#kubectl delete configmap nginx-deploy-agent-conf --namespace=synctree > /dev/null 2>&1
#kubectl create configmap nginx-deploy-agent-conf --from-file=./conf.d/deploy-agent.conf --namespace=synctree
#kubectl delete configmap nginx-rfc-conf --namespace=synctree > /dev/null 2>&1
#kubectl create configmap nginx-rfc-conf --from-file=./conf.d/rfc.conf --namespace=synctree
#kubectl delete configmap nginx-debugger-conf --namespace=synctree > /dev/null 2>&1
#kubectl create configmap nginx-debugger-conf --from-file=./conf.d/debugger.conf --namespace=synctree
#kubectl delete configmap nginx-dsocket-conf --namespace=synctree > /dev/null 2>&1
#kubectl create configmap nginx-dsocket-conf --from-file=./conf.d/dsocket.conf --namespace=synctree


# services

kubectl apply -f ./studio.yaml --namespace=synctree
kubectl apply -f ./tool.yaml --namespace=synctree
kubectl apply -f ./tool-proxy.yaml --namespace=synctree
kubectl apply -f ./testing.yaml --namespace=synctree
kubectl apply -f ./portal.yaml --namespace=synctree
kubectl apply -f ./portal-admin.yaml --namespace=synctree
#kubectl apply -f ./batch.yaml --namespace=synctree
#kubectl apply -f ./deploy-agent.yaml --namespace=synctree
#kubectl apply -f ./rfc.yaml --namespace=synctree
#kubectl apply -f ./debugger.yaml --namespace=synctree
#kubectl apply -f ./dsocket.yaml --namespace=synctree
#kubectl apply -f ./pvc.yaml --namespace=synctree
#kubectl apply -f ./hpa.yaml --namespace=synctree

# ingress
#kubectl apply -f ./ingress.yaml --namespace=synctree
