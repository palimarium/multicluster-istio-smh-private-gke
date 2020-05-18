#!/usr/bin/env bash

set -euo pipefail
source ./env.sh


#Create Cloud Router for europe-west2 egress traffic
gcloud compute routers create $REGION_CLUSTER1-nat-router \
    --network cross-region-vpc \
    --region $REGION_CLUSTER1


#Add a configuration to the europe-west2 router
gcloud compute routers nats create nat-eu-west2 \
    --router-region $REGION_CLUSTER1 \
    --router $REGION_CLUSTER1-nat-router \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips

#####################################################

#Create Cloud Router for us-central1 egress traffic
gcloud compute routers create $REGION_CLUSTER2-nat-router \
    --network cross-region-vpc \
    --region $REGION_CLUSTER2


#Add a configuration to the us-central1 router
gcloud compute routers nats create nat-us-central1 \
    --router-region $REGION_CLUSTER2 \
    --router $REGION_CLUSTER2-nat-router \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips

