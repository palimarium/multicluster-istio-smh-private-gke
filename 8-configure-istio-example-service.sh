#!/usr/bin/env bash

set -euo pipefail
source ./env.sh


# Deploy the sleep service in cluster1.

kubectl create --context=$CTX_CLUSTER1 namespace foo
kubectl label --context=$CTX_CLUSTER1 namespace foo istio-injection=enabled
kubectl apply --context=$CTX_CLUSTER1 -n foo -f https://raw.githubusercontent.com/istio/istio/release-1.5/samples/sleep/sleep.yaml

# Deploy the httpbin service in cluster2.

kubectl create --context=$CTX_CLUSTER2 namespace bar
kubectl label --context=$CTX_CLUSTER2 namespace bar istio-injection=enabled
kubectl apply --context=$CTX_CLUSTER2 -n bar -f https://raw.githubusercontent.com/istio/istio/release-1.5/samples/httpbin/httpbin.yaml

echo "Patching KubeDNS & CoreDNS on Cluster1..."
# Patch CoreDNS on cluster1
./resources/patch-CoreDNS.sh "gke_${PROJECT_ID}_${ZONE_CLUSTER1}_${NAME_CLUSTER1}"

echo "Patching KubeDNS & CoreDNS on Cluster2..."
# Patch CoreDNS on cluster2
./resources/patch-CoreDNS.sh "gke_${PROJECT_ID}_${ZONE_CLUSTER2}_${NAME_CLUSTER2}"

echo "Wait 10 sec before checking that httpbin is accessible from the sleep service and return 200 OK..."
sleep 10

#Verify that httpbin is accessible from the sleep service.
export SLEEP_POD=$(kubectl get --context=$CTX_CLUSTER1 -n foo pod -l app=sleep -o jsonpath={.items..metadata.name})
kubectl exec --context=$CTX_CLUSTER1 $SLEEP_POD -n foo -c sleep -- curl -I httpbin.bar.cluster-2:8000/headers
