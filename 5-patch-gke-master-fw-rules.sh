#!/usr/bin/env bash

set -euo pipefail
source ./env.sh

## For private GKE clusters
## An automatically created firewall rule does not open port 15017. This is needed by the Pilot discovery validation webhook
## https://istio.io/docs/setup/platform-setup/gke/

# Get the name of the existing fw rules
cluster1_fw_rule=$(gcloud compute firewall-rules list --format="table(name)" --filter="name~gke-istio-cluster[0-9]*-[0-9a-z]*-master" |  sed -n 2p )
cluster2_fw_rule=$(gcloud compute firewall-rules list --format="table(name)" --filter="name~gke-istio-cluster[0-9]*-[0-9a-z]*-master" |  sed -n 3p )


# Replace the existing rule and allow master access:
gcloud compute firewall-rules update $cluster1_fw_rule --allow tcp:10250,tcp:443,tcp:15017
gcloud compute firewall-rules update $cluster2_fw_rule --allow tcp:10250,tcp:443,tcp:15017
