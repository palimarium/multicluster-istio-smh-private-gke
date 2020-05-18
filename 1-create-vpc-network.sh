#!/usr/bin/env bash

set -euo pipefail
source ./env.sh

gcloud config set project $PROJECT_ID

# Create custom mode VPC network
gcloud compute networks create cross-region-vpc \
    --subnet-mode=custom \
    --bgp-routing-mode=regional

#Create eu subnet in our custom VPC Network
gcloud compute networks subnets create eu-ilb-subnet \
    --network=cross-region-vpc \
    --range=172.20.0.0/20 \
    --region=$REGION_CLUSTER1

#Create us subnet in our custom VPC Network
gcloud compute networks subnets create us-ilb-subnet \
    --network=cross-region-vpc \
    --range=172.21.0.0/20 \
    --region=$REGION_CLUSTER2
