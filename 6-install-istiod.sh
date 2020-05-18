#!/usr/bin/env bash

set -euo pipefail
source ./env.sh

#Install prerequisites

curl -sL https://run.solo.io/meshctl/install | sh
sudo apt-get update && sudo apt-get install -y kubectl

#Cluster 1
gcloud config set project $PROJECT_ID
gcloud container clusters get-credentials $NAME_CLUSTER1 --zone $ZONE_CLUSTER1

#Cluster 2
gcloud container clusters get-credentials $NAME_CLUSTER2 --zone $ZONE_CLUSTER2


#Install istio on cluster1 

meshctl mesh install istio --context $CTX_CLUSTER1 --operator-spec=resources/istio-spec-cluster-eu.yaml

#Install istio on cluster2

meshctl mesh install istio --context $CTX_CLUSTER2 --operator-spec=resources/istio-spec-cluster-us.yaml

echo "Wait 1 min. for Istio Operator to complete Istiod installation..."
sleep 60

