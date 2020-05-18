#!/usr/bin/env bash

set -euo pipefail
source ./env.sh


# Create Private GKE Cluster 1 in europe-west2

gcloud beta container clusters create $NAME_CLUSTER1 --project $PROJECT_ID --zone $ZONE_CLUSTER1 \
--machine-type "n1-standard-2" --image-type "COS" --disk-size "100" --enable-ip-alias --enable-master-global-access \
--enable-private-nodes --enable-private-endpoint --no-enable-basic-auth --master-ipv4-cidr "172.16.0.32/28" \
--enable-ip-alias --network "projects/$PROJECT_ID/global/networks/cross-region-vpc" \
--subnetwork "projects/$PROJECT_ID/regions/$REGION_CLUSTER1/subnetworks/eu-ilb-subnet" --cluster-ipv4-cidr "10.16.32.0/20"  \
--services-ipv4-cidr "172.16.5.0/24" --default-max-pods-per-node "110" --enable-master-authorized-networks  \
--master-authorized-networks 172.20.0.0/20,172.21.0.0/20,10.16.48.0/20 --num-nodes "3" --preemptible --release-channel=rapid &

# Create Private GKE Cluster 2 in us-central1

gcloud beta container clusters create $NAME_CLUSTER2 --project $PROJECT_ID --zone $ZONE_CLUSTER2 \
--machine-type "n1-standard-2" --image-type "COS" --disk-size "100" --enable-ip-alias --enable-master-global-access \
--enable-private-nodes --enable-private-endpoint --no-enable-basic-auth --master-ipv4-cidr "172.16.0.64/28" \
--enable-ip-alias --network "projects/$PROJECT_ID/global/networks/cross-region-vpc" \
--subnetwork "projects/$PROJECT_ID/regions/$REGION_CLUSTER2/subnetworks/us-ilb-subnet" --cluster-ipv4-cidr "10.16.48.0/20"  \
--services-ipv4-cidr "172.16.6.0/24" --default-max-pods-per-node "110" --enable-master-authorized-networks  \
--master-authorized-networks 172.20.0.0/20,172.21.0.0/20,10.16.32.0/20 --num-nodes "3" --preemptible --release-channel=rapid &

# wait for clusters to be created
wait < <(jobs -p)
