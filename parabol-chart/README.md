# Deploying the Helm Chart with Custom Values

This README provides guidance on how to deploy a Helm chart using the provided `values.yaml` file, upgrade the deployed chart, and uninstall the release. 

## Prerequisites

1. Ensure Helm is installed. If not, you can install Helm by following the official documentation: [Installing Helm](https://helm.sh/docs/intro/install/).
2. Kubernetes cluster setup and `kubectl` installed.
3. Access to the specified image registry. Ensure you have permissions to pull images.

## Instructions

### 1. Login to the Image Registry to pull latest images (only required for K3D)

Log in to the image registry specified in the values file using the provided credentials.

```bash
docker login registry1.dso.mil -u <USERNAME> -p <PASSWORD>
```

### 2. Deploying the Helm Chart

To deploy the Helm chart using the provided `values.yaml` file, use the following command:

```bash
helm install -i -n parabol --values ./parabol-chart/Values.yaml --create-namespace parabol ./parabol-chart
```

### 3. Upgrading the Helm Chart

To upgrade the deployed Helm chart with changes made to the `values.yaml` file or the chart itself:

```bash
helm upgrade -i -n parabol --values ./parabol-chart/Values.yaml --create-namespace parabol ./parabol-chart
```

### 4. Uninstalling the Helm Release

To uninstall/delete the deployed Helm release:

```bash
helm uninstall parabol -n=parabol
```

## `values.yaml` Overview

The provided `values.yaml` contains configurations for deploying services like Redis, RethinkDB, PostgreSQL, and Parabol. Here's a brief explanation:

- **imageRegistry**: Specifies the registry details like host, username, and password.
- **services**: Defines the images and configurations for each service.
- **ingress**: If enabled, it sets up an ingress resource with the provided hostname.
- **parabolEnv**: Environment variables specific to the Parabol service.
- **postgresEnv**: Environment variables specific to the PostgreSQL service.

Make sure not to expose sensitive details like passwords in the `values.yaml`. It's preferable to use Kubernetes secrets for sensitive data.

## Security Note

It's essential to treat the `values.yaml` file with care, especially if it contains sensitive data like passwords. Avoid committing the file with actual passwords to version control systems. Instead, consider using Helm secrets or Kubernetes secrets to manage sensitive values.

## Configuration Note

You will have to update `dockerconfigjson` and `Values.yaml` with proper registry information.