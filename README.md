# multicluster-istio-smh-private-gke


## Introduction

This demo shows you how to build a private multicluster service mesh solution, with Istio 1.5 and Service Mesh Hub for mesh Federation. This is achieved by using an Internal Load Balancer (ILB) to connect Istio workloads running in multi-region Private Google Kubernetes Engine (GKE) clusters.



## Implementation Architecture

In this demo, we will build the following architecture:

![arch-diagram](resources/images/ilb_multicluster_Istio.png)


## Prerequisites


- A GCP project with billing enabled
- gcloud CLI
- kubectl

<br/>

## Set project variables

```
❯ export PROJECT_ID=<your-project-id>
```

<br/>

### 1. Create a custom VPC network with 2 subnets in different regions:

```
my@localhost:~$./1-create-vpc-network.sh
```

 <br/>

### 2. Create the clusters:


```
my@localhost:~$./2-create-private-gke-clusters.sh
```
<br/>

### 3. Create CloudNAT for providing Internet access to the private GKE clusters

```
my@localhost:~$./3-create-cloudnat-for-private-gke-clusters.sh
```
<br/>

### 4. For private GKE clusters, an automatically created firewall rule does not open port 15017. This is needed by the Pilot discovery validation webhook

```
my@localhost:~$./4-patch-gke-master-fw-rules.sh
```
<br/>

### 5. Create a jump host VM in the same zone as one of the gke clusters

```
my@localhost:~$./5-create-jump-host-vm.sh
```

### 5.1 ssh into the GCE instance to run the remaining step **6,7 and 8**:

```
❯ gcloud beta compute ssh --zone "europe-west2-a" "jump-host" --tunnel-through-iap --project $PROJECT_ID
```

### 5.2 Install package dependencies

```
my@jump-host:~$ sudo apt-get install -y git kubectl
```

### 5.3 Set project variables

```
❯ export PROJECT_ID=<your-project-id>
```

### 5.4 Clone git repo on jumphost:

```
❯ git clone https://github.com/palimarium/multicluster-istio-smh-private-gke
```
### 5.5 Authenticate on jumphost VM with your gcp account

```
my@jump-host:~/multicluster-istio-smh-private-gke$ gcloud auth login
```

 <br/>

## Install Istio on Both Clusters


### 6. Install Istio using the Istio operator


```
my@jump-host:~$./6-install-istiod.sh
```

 <br/>


## Configure Service Mesh Hub


### 7. Install Sevice Mesh Hub

```
my@jump-host:~$./7-configure-service-mesh-hub.sh
```
<br/>

## Deploy the Sample App and configure KubeDNS to talk to Istio's CoreDNS

### 8. Configure the example services

```
my@jump-host:~$./8-configure-istio-example-service.sh
```

<br/>
<br/>
<br/>
<br/>    


# Cleanup

1. **Source env file**

```
❯ source ./env.sh
```

2. **Delete the GCE VM:**

```
❯ gcloud beta compute --project=$PROJECT_ID instances delete jump-host --zone=$ZONE_CLUSTER1
```

3. **Delete FW rule for iap access**

```
❯ gcloud compute --project=$PROJECT_ID firewall-rules delete allow-jump-host-iap  

```

4. **Delete the GKE Clusters:**

```
❯ gcloud beta container clusters delete $NAME_CLUSTER1 --project $PROJECT_ID --zone $ZONE_CLUSTER1
```

```
❯ gcloud beta container clusters delete $NAME_CLUSTER2 --project $PROJECT_ID --zone $ZONE_CLUSTER2
```

5. **Delete CloudNAT**

```
❯ gcloud compute routers nats delete nat-eu-west2 --router $REGION_CLUSTER1-nat-router --router-region $REGION_CLUSTER1
```

```
❯ gcloud compute routers nats delete nat-us-central1 --router $REGION_CLUSTER2-nat-router --router-region $REGION_CLUSTER2
```

6. **Delete CloudRouter**

```
❯ gcloud compute routers delete $REGION_CLUSTER1-nat-router --region $REGION_CLUSTER1
```

```
❯ gcloud compute routers delete $REGION_CLUSTER2-nat-router --region $REGION_CLUSTER2
```

7. **Delete subnetworks**

```
❯ gcloud compute networks subnets delete eu-ilb-subnet --region=$REGION_CLUSTER1
```

```
❯ gcloud compute networks subnets delete us-ilb-subnet --region=$REGION_CLUSTER2
```

8. **Delete custom VPC network**

```
❯ gcloud compute networks delete cross-region-vpc
```

<br/>
<br/>

## Further reading

- To learn about Service mesh hub, see the [docs](https://docs.solo.io/service-mesh-hub/latest/getting_started/)
- To learn how to configure and install the different modes, see the [Setup](https://istio.io/docs/setup/install/multicluster/) section in the Istio docs.