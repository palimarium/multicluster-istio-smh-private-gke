#!/usr/bin/env bash

set -euo pipefail
source ./env.sh


# Create Jump-host VM with no external ip

gcloud beta compute --project=$PROJECT_ID instances create jump-host --zone=$ZONE_CLUSTER1 --machine-type=g1-small --subnet=eu-ilb-subnet --no-address --tags=jump-host

# Create FW rule for allowing IAP access to jump-host

gcloud compute --project=$PROJECT_ID firewall-rules create allow-jump-host-iap --direction=INGRESS --priority=1000 --network=cross-region-vpc --action=ALLOW --rules=tcp --source-ranges=35.235.240.0/20 --target-tags=jump-host
