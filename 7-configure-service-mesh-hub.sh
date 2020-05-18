#!/usr/bin/env bash

set -euo pipefail
source ./env.sh

#Cluster 1
gcloud config set project $PROJECT_ID
gcloud container clusters get-credentials $NAME_CLUSTER1 --zone $ZONE_CLUSTER1

#Cluster 2
gcloud container clusters get-credentials $NAME_CLUSTER2 --zone $ZONE_CLUSTER2


#Installing  service mesh hub

meshctl install --context $CTX_CLUSTER1

#Verify install
sleep 11
meshctl check --context $CTX_CLUSTER1

#Discover Kubernetes Clusters

meshctl get kubernetescluster --context $CTX_CLUSTER1

#Register clusters  in Service mesh hub

##Cluster1
kubectl config use-context $CTX_CLUSTER1
meshctl cluster register --remote-cluster-name cluster-1 --remote-context $CTX_CLUSTER1 

##Cluster2
kubectl config use-context $CTX_CLUSTER1
meshctl cluster register  --remote-cluster-name cluster-2  --remote-context $CTX_CLUSTER2
echo "Wait 20 sec for service mesh discovery to finish..."
sleep 20

#############################################
# Trust Federation
#############################################


#Create a Virtual Mesh
kubectl config use-context $CTX_CLUSTER1
kubectl apply -f resources/virtual-mesh.yaml 


#Bounce the istio pod to pick up the new cert
echo "Wait 20 sec for trust federation to finish before bouncing the istiod pod ..."
sleep 20

kubectl delete pod -n istio-system -l app=istiod --context $CTX_CLUSTER1

kubectl delete pod -n istio-system -l app=istiod --context $CTX_CLUSTER2
