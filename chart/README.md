# parabol

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

A Helm chart to deploy redis, rethinkdb, postgres, and parabol containers.

## Deploying the Helm Chart with Custom Values

This README provides guidance on how to deploy a Helm chart using the provided `values.yaml` file, upgrade the deployed chart, and uninstall the release.

### Prerequisites

1. Ensure Helm is installed. If not, you can install Helm by following the official documentation: [Installing Helm](https://helm.sh/docs/intro/install/).
2. Kubernetes cluster setup and `kubectl` installed.
3. Access to the specified image registry. Ensure you have permissions to pull images.

### Minimum Resource Requirements

Each Parabol deployment may require differing CPU, RAM, and storage requirements based upon the number of users and intensity of usage. From experience here are the minimums we suggest to support an installation supporting 10 to 1,000 users. The following assumes the higher end of 1,000 users with the tech stack consisting of Parabol, RethinkDB, Postgres, and Redis running in Kubernetes (for physical or virtual machines adjust accordingly to match).

``` yaml
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

By default Parabol is deployed without minimum allocations for cpu and memory. To change the resources configurations allocated to Parabol, add the above yaml to the `resources` section within the values file for each deployment (parabol, rethinkdb, redis, or postgres). Add at least the minimums from the `Minimum Resource Requirements` above and re-deploy the helm chart.

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

## Values Overview

The provided `values.yaml` contains configurations for deploying services like Redis, RethinkDB, PostgreSQL, and Parabol. Here's a brief explanation:

- **imageRegistry**: Specifies the registry details like host, username, and password.
- **services**: Defines the images and configurations for each service.
- **ingress**: If enabled, it sets up an istio virtualService resource with the provided hostname.
- **parabolDeployment**: Configuration and environment variables specific to the Parabol service.
- **postgresDeployment**: Configuration and environment variables specific to the PostgreSQL service.
- **monitoring**: Configuration specific to monitoring services deployed alongside Parabol. If enabled the following resources are created:
  - Servicemonitor resource is created to surface metrics to prom-operator running in the monitoring namespace
  - Grafana dashboards are enabled to view those metrics
  - Alertmanager rules are enabled for Redis and Postgres

Make sure not to expose sensitive details like passwords in the `values.yaml`. It's preferable to use Kubernetes secrets for sensitive data.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| database.env.postgresDb | string | `"parabol"` | Name of the PostgreSQL database. |
| database.env.postgresHost | string | `"postgres-service.parabol.svc.cluster.local"` | Internal hostname used to access the PostgreSQL database. |
| database.env.postgresPassword | string | `"parabol"` | Password to access the PostgreSQL database. |
| database.env.postgresPort | int | `5432` | Port on which the PostgreSQL server is listening. |
| database.env.postgresUser | string | `"postgres"` | Username to access the PostgreSQL database. |
| imageRegistry.host | string | `"registry1.dso.mil"` | Container registry hostname |
| ingress.enabled | bool | `true` | Enables external routing to Parabol service via Istio |
| ingress.hostname | string | `"parabol.bigbang.dev"` | The external hostname for Parabol application |
| monitoring.dashboards.label | string | `"grafana_dashboard"` | Grafana dashboard labels to check |
| monitoring.dashboards.namespace | string | `"monitoring"` | K8s namespace where the monitoring stack is deployed |
| monitoring.enabled | bool | `true` | Enable BigBang Monitoring resources |
| monitoring.postgres.env[0] | object | `{"name":"DATA_SOURCE_NAME","value":"postgresql://postgres:parabol@localhost:5432/parabol?sslmode=disable"}` | Postgres exporter env vars |
| monitoring.postgres.metricsPort | int | `9187` | Port that Postgres metrics are exposed on |
| monitoring.redis.metricsPort | int | `9121` | Port that Redis metrics are exposed on |
| parabolDeployment.env.authGooleDisabled | bool | `false` | Flag indicating if Google authentication is disabled ("true" or "false"). |
| parabolDeployment.env.authInternalDisabled | bool | `false` | Flag indicating if internal username/password authentication is disabled ("true" or "false"). |
| parabolDeployment.env.authSsoDisabled | bool | `false` | Flag indicating if Single Sign-On (SSO) authentication is disabled ("true" or "false"). |
| parabolDeployment.env.fileStoreProvider | string | `"local"` | fileStoreProvider: Specifies the provider for file storage - "local" means local file-based storage is used |
| parabolDeployment.env.host | string | `"parabol.bigbang.dev"` | The external hostname for Parabol application |
| parabolDeployment.env.invitationShortlink | string | `"parabol.bigbang.dev/invitation-link"` | The base URL used to construct invitation shortlinks. |
| parabolDeployment.env.isEnterprise | bool | `true` | Flag indicating if the default tier for the instance is Enterprise. Use this for privately managed instances to make all new orgs, teams, and users enterprise tier. This flag is implemented in 7.2.0 or greater. |
| parabolDeployment.env.port | int | `3000` | The port on which the application will be exposed. |
| parabolDeployment.env.protocol | string | `"http"` | The protocol used by the server ("http" or "https"). |
| parabolDeployment.env.redisUrl | string | `"redis://redis-service.parabol.svc.cluster.local:6379"` | The URL used to access the Redis server. |
| parabolDeployment.env.rethinkdbUrl | string | `"rethinkdb://rethinkdb-service.parabol.svc.cluster.local:28015/actionDevelopment"` | The URL used to access the RethinkDB server. |
| parabolDeployment.env.serverId | int | `1` | Identifier for the server (useful in scaled/multi-server environments). |
| parabolDeployment.env.serverSecret | string | `"QmtzUGVRUXJSa1hoRHJ1Z3pRRGc1TncK"` | The secret key used to generate JWT tokens |
| parabolDeployment.livenessProbe | list | `[]` |  |
| parabolDeployment.readinessProbe.failureThreshold | int | `3` | How many time should the check fail before restarting |
| parabolDeployment.readinessProbe.httpGet.path | string | `"/manifest.json"` | Path to HTTP check |
| parabolDeployment.readinessProbe.httpGet.port | int | `3000` | Port for HTTP check |
| parabolDeployment.readinessProbe.initialDelaySeconds | int | `30` | Delay before checking for readiness |
| parabolDeployment.readinessProbe.periodSeconds | int | `10` | The amount of time to check for |
| parabolDeployment.readinessProbe.successThreshold | int | `1` | How many successes should the check have before ready |
| parabolDeployment.readinessProbe.timeoutSeconds | int | `5` | How long before the check timesout |
| parabolDeployment.startupProbe.failureThreshold | int | `3` | How many time should the check fail before restarting |
| parabolDeployment.startupProbe.httpGet.path | string | `"/manifest.json"` | Path to HTTP check |
| parabolDeployment.startupProbe.httpGet.port | int | `3000` | Port for HTTP check |
| parabolDeployment.startupProbe.periodSeconds | int | `30` | The amount of time to check for |
| registryCredentials.password | string | `nil` |  |
| registryCredentials.username | string | `nil` | Username container registry |
| services.parabol.env.postgresHost | string | `"postgres-service"` | Parabol config to reach Postgresql |
| services.parabol.env.redisHost | string | `"redis-service"` | Parabol config to reach Redis |
| services.parabol.env.rethinkdbHost | string | `"rethinkdb-service"` | Parabol config to reach RethinkDB |
| services.parabol.image | string | `"ironbank/parabol/parabol:6.124.0"` | Image to use for deploying Parabol |
| services.parabol.localStorage.enabled | bool | `true` | Use PersistentVolumeClaim for RethinkDB storage |
| services.parabol.localStorage.volumeSize | string | `"1Gi"` | Size of PVC volume used |
| services.parabol.ports.external | int | `80` | Exposed port for Parabol to run external to cluster |
| services.parabol.ports.internal | int | `3000` | Exposed port for Parabol to run internal to cluster |
| services.parabol.serviceName | string | `"parabol-stateful-set"` | Service name of Stateful Set |
| services.parabol.replicas | int | `1` | Number of replicas to deploy |
| services.parabol.resources | object | `{}` | Container resource requests and limits |
| services.postgres.backups.enabled | bool | `false` | Enable automatic backups |
| services.postgres.backups.restore | bool | `false` | Enable restore job from last backup |
| services.postgres.backups.schedule | string | `"0 2 * * *"` | Schedule for backup jobs example - run every day at 3am |
| services.postgres.backups.volumeSize | string | `"10Gi"` | Size of PVC volume used |
| services.postgres.exporter | string | `"ironbank/opensource/prometheus/postgres-exporter:v0.13.2"` | Image to use for deploying Postgres exporter for monitoring |
| services.postgres.image | string | `"ironbank/opensource/postgres/postgresql:15.4"` | Image to use for deploying PostgreSql |
| services.postgres.localStorage.enabled | bool | `true` | Use PersistentVolumeClaim for RethinkDB storage |
| services.postgres.localStorage.volumeSize | string | `"10Gi"` | Size of PVC volume used |
| services.postgres.resources | object | `{}` | Container resource requests and limits |
| services.redis.exporter | string | `"ironbank/bitnami/analytics/redis-exporter:v1.54.0"` | Image to use for deploying Redis exporter for monitoring |
| services.redis.image | string | `"ironbank/opensource/redis/redis6-alpine:6.2.13"` | Image to use for deploying Redis |
| services.redis.localStorage | object | `{"enabled":true}` | Use PersistentVolumeClaim for Redis storage |
| services.redis.resources | object | `{}` | resource requests and limits |
| services.rethinkdb.backups.enabled | bool | `false` | Enable automatic backups |
| services.rethinkdb.backups.restore | bool | `false` | Enable restore job from last backup |
| services.rethinkdb.backups.schedule | string | `"0 3 * * *"` | Schedule for backup jobs example - run every day at 3am |
| services.rethinkdb.backups.volumeSize | string | `"10Gi"` | Size of PVC volume used |
| services.rethinkdb.image | string | `"ironbank/opensource/rethinkdb/rethinkdb:2.4.1.u1"` | Image to use for deploying ReThinkDB |
| services.rethinkdb.localStorage.enabled | bool | `true` | Use PersistentVolumeClaim for RethinkDB storage |
| services.rethinkdb.localStorage.volumeSize | string | `"10Gi"` | Size of PVC volume used |
| services.rethinkdb.resources | object | `{}` | Container resource requests and limits |

## Security Notes

It's essential to treat the `values.yaml` file with care, especially if it contains sensitive data like passwords. Avoid committing the file with actual passwords to version control systems. Instead, consider using Helm secrets or Kubernetes secrets to manage sensitive values.

## Configuration Notes

You will have to update `dockerconfigjson` and `registryCredentials.username & registryCredentials.password` in your values file with proper registry information.
