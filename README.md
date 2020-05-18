# multicluster-istio-smh-private-gke

This demo shows how you can build a private multicluster service mesh solution, with Istio 1.5 and Service Mesh Hub for mesh Federation by using an Internal Load Balancer (ILB) to connect Istio workloads running in Private Google Kubernetes Engine (GKE) cross-regions clusters.

## Implementation Architecture

In this demo, we will build the following architecture:

![arch-diagram](resources/images/ilb_multicluster_Istio.png)


## Prerequisites

- A GCP project with billing enabled
- gcloud CLI
- kubectl

## Create a GKE Cluster

1. **Export project ID:**

```
PROJECT_ID=<your-project-id>
```

2. **Create a custom VPC network:**


3. **Create the clusters:**

