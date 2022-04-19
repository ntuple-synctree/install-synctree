#!/bin/bash

# secret
kubectl delete secret private-repo --namespace=synctree

# configmap
kubectl delete configmap deploy-configmap --namespace=synctree

# nginx-confs
kubectl delete configmap nginx-studio-conf --namespace=synctree
kubectl delete configmap nginx-tool-conf --namespace=synctree
kubectl delete configmap nginx-tool-proxy-conf --namespace=synctree
kubectl delete configmap nginx-testing-conf --namespace=synctree
kubectl delete configmap nginx-batch-conf --namespace=synctree
kubectl delete configmap nginx-portal-conf --namespace=synctree
#kubectl delete configmap nginx-deploy-agent-conf --namespace=synctree

# services
kubectl delete -f ./studio.yaml --namespace=synctree
kubectl delete -f ./tool.yaml --namespace=synctree
kubectl delete -f ./tool-proxy.yaml --namespace=synctree
kubectl delete -f ./testing.yaml --namespace=synctree
kubectl delete -f ./batch.yaml --namespace=synctree
kubectl delete -f ./portal.yaml --namespace=synctree
#kubectl delete -f ./deploy-agent.yaml --namespace=synctree

# ingress
#kubectl delete -f ./ingress.yaml --namespace=synctree
