# Deploying the Helm Chart with Custom Values

This README provides guidance on how to deploy a Helm chart using the provided `values.yaml` file, upgrade the deployed chart, and uninstall the release. 

## Prerequisites

1. Ensure Helm is installed. If not, you can install Helm by following the official documentation: [Installing Helm](https://helm.sh/docs/intro/install/).
2. Kubernetes cluster setup and `kubectl` installed.
3. Access to the specified image registry. Ensure you have permissions to pull images.

## Minimum Resource Requirements

Each Parabol deployment may require differing CPU, RAM, and storage requirements based upon the number of users and intensity of usage. From experience here are the minimums we suggest to support an installation supporting 10 to 1,000 users. The following assumes the higher end of 1,000 users with the tech stack consisting of Parabol, RethinkDB, Postgres, and Redis running in Kubernetes (for physical or virtual machines adjust accordingly to match). 
```
CPU and Memory:
    Parabol
        limits:
          cpu: 2
          memory: 12Gi
        requests:
          cpu: 1
          memory: 6Gi
    RethinkDB
        limits:
          cpu: 2
          memory: 4Gi
        requests:
          cpu: 1
          memory: 2Gi
    Redis
        limits:
          cpu: 1
          memory: 2Gi
        requests:
          cpu: 0.5
          memory: 512Mi
    Postgres
        limits:
          cpu: 2
          memory: 3Gi
        requests:
          cpu: 1
          memory: 1Gi

Storage:
    Parabol PVC: minimum 1Gi
    RethinkDB PVC: minimum 3Gi
    Redis PVC: minimum 500Mi
    Postgres PVC: minimum 3Gi

```

### Changing Resource Allocation

By default Parabol is deployed without minimum allocations for cpu and memory. To change the resources configurations allocated to Parabol create a `resrouces` section within each deployment file e.g. `chart/templates/<deployment>-deployment.yaml` (for each deployment parabol, rethinkdb, redis, or postgres). Add the `resources` section to the `containers` section and apply at least the minimums from the `Minimum Resource Requirements` above.

## Instructions

### 1. Login to the Image Registry to pull latest images (only required for K3D)

Log in to the image registry specified in the values file using the provided credentials.

```bash
docker login registry1.dso.mil -u <USERNAME> -p <PASSWORD>
```

### 2. Installing or Upgrading the Helm Chart

To install or upgrade the deployed Helm chart with changes made to the `values.yaml` file or the chart itself:

```bash
helm upgrade -i -n parabol --values ./chart/values.yaml --create-namespace parabol ./chart
```

### 3. Uninstalling the Helm Release

To uninstall/delete the deployed Helm release:

```bash
helm uninstall parabol -n parabol
```

## `values.yaml` Overview

The provided `values.yaml` contains configurations for deploying services like Redis, RethinkDB, PostgreSQL, and Parabol. Here's a brief explanation:

- **imageRegistry**: Specifies the registry details like host, username, and password.
- **services**: Defines the images and configurations for each service.
- **ingress**: If enabled, it sets up an ingress resource with the provided hostname.
- **parabolDeployment**: Configuration and environment variables specific to the Parabol service.
- **postgresDeployment**: Configuration and environment variables specific to the PostgreSQL service.
- **monitoring**: Configuration specific to monitoring services deployed alongside Parabol. If enabled the following resources are created:
    -  Servicemonitor resource is created to surface metrics to prom-operator running in the monitoring namespace
    -  Grafana dashboards are enabled to view those metrics
    -  Alertmanager rules are enabled for Redis and Postgres

Make sure not to expose sensitive details like passwords in the `values.yaml`. It's preferable to use Kubernetes secrets for sensitive data.

Note: the `values.yaml` contains comments that document what each key-value pair configures.

## Security Notes

It's essential to treat the `values.yaml` file with care, especially if it contains sensitive data like passwords. Avoid committing the file with actual passwords to version control systems. Instead, consider using Helm secrets or Kubernetes secrets to manage sensitive values.

## Configuration Notes

You will have to update `dockerconfigjson` and `values.yaml` with proper registry information.
