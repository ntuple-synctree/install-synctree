#!/bin/bash

# configmap
kubectl delete configmap deploy-configmap --namespace=synctree

# nginx-confs
kubectl delete configmap nginx-studio-conf --namespace=synctree
kubectl delete configmap nginx-tool-conf --namespace=synctree
kubectl delete configmap nginx-tool-proxy-conf --namespace=synctree
kubectl delete configmap nginx-testing-conf --namespace=synctree
kubectl delete configmap nginx-portal-conf --namespace=synctree
kubectl delete configmap nginx-portal-admin-conf --namespace=synctree
#kubectl delete configmap nginx-batch-conf --namespace=synctree
#kubectl delete configmap nginx-deploy-agent-conf --namespace=synctree
#kubectl delete configmap nginx-rfc-conf --namespace=synctree
#kubectl delete configmap nginx-debugger-conf --namespace=synctree
#kubectl delete configmap nginx-dsocket-conf --namespace=synctree

# services
kubectl delete -f ./studio.yaml --namespace=synctree
kubectl delete -f ./tool.yaml --namespace=synctree
kubectl delete -f ./tool-proxy.yaml --namespace=synctree
kubectl delete -f ./testing.yaml --namespace=synctree
kubectl delete -f ./portal.yaml --namespace=synctree
kubectl delete -f ./portal-admin.yaml --namespace=synctree
#kubectl delete -f ./batch.yaml --namespace=synctree
#kubectl delete -f ./deploy-agent.yaml --namespace=synctree
#kubectl delete -f ./rfc.yaml --namespace=synctree
#kubectl delete -f ./dsocket.yaml --namespace=synctree
#kubectl delete -f ./debugger.yaml --namespace=synctree
#kubectl delete -f ./hpa.yaml --namespace=synctree

# ingress
#kubectl delete -f ./ingress.yaml --namespace=synctree
