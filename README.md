# multicluster-istio-smh-private-gke


## Introduction

This demo shows you how to build a private multicluster service mesh solution, with Istio 1.5 and Service Mesh Hub for mesh Federation. This is achieved by using an Internal Load Balancer (ILB) to connect Istio workloads running in multi-region Private Google Kubernetes Engine (GKE) clusters.

#

## Implementation Architecture

In this demo, we will build the following architecture:

![arch-diagram](resources/images/ilb_multicluster_Istio.png)


## Prerequisites

- A GCP project with billing enabled
- gcloud CLI
- kubectl

## Set project variables

```
export PROJECT_ID=<your-project-id>
```



1. **Create a custom VPC network with 2 subnets in different regions:**

```
my@localhost:~$./1-create-vpc-network.sh
```


2. **Create the clusters:**


```
my@localhost:~$./2-create-private-gke-clusters.sh
```
3. **Create CloudNAT for providing Internet access to the private GKE clusters**

```
my@localhost:~$./3-create-cloudnat-for-private-gke-clusters.sh
```
4. **For private GKE clusters, an automatically created firewall rule does not open port 15017. This is needed by the Pilot discovery validation webhook**

```
my@localhost:~$./4-patch-gke-master-fw-rules.sh
```
5. **Create a jump host VM in the same zone as one of the gke clusters**

```
my@localhost:~$./5-create-jump-host-vm.sh
```

5.1 **ssh into the GCE instance to run the remaining step 6,7 and 8:**

```
gcloud beta compute ssh --zone "europe-west2-a" "jump-host" --tunnel-through-iap --project "<your-project-id>"
```
5.2 **Set project variables**

```
export PROJECT_ID=<your-project-id>
```

5.3 **Clone git repo on jumphost:**

```
git clone https://github.com/palimarium/multicluster-istio-smh-private-gke
```

## Install Istio on Both Clusters

6. **Install Istio using the Istio operator**


```
my@jump-host:~$./6-install-istiod.sh
```


## Configure Service Mesh Hub

7. **Install Sevice Mesh Hub**

```
my@jump-host:~$./7-configure-service-mesh-hub.sh
```


## Deploy the Sample App and configure KubeDNS to talk to Istio's CoreDNS

8. **Configure the example services**

```
my@jump-host:~$./8-configure-istio-example-service.sh
```


***

## Cleanup

1. **Delete the GCE VM:**
2. **Delete the GKE Clusters:**
3. **Delete CloudNAT**




## Further reading

- To learn about Multicluster Istio and its different modes, see the Istio docs
- To learn how to configure and install the different modes, see the Setup section in the Istio docs.