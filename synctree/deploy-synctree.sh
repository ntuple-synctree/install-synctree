#!/bin/bash

# namespace 
kubectl create namespace synctree > /dev/null 2>&1

# secret
kubectl delete secret private-repo --namespace=synctree > /dev/null 2>&1

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

# services
kubectl apply -f ./studio.yaml --namespace=synctree
kubectl apply -f ./tool.yaml --namespace=synctree
kubectl apply -f ./tool-proxy.yaml --namespace=synctree
kubectl apply -f ./testing.yaml --namespace=synctree
kubectl apply -f ./portal.yaml --namespace=synctree

