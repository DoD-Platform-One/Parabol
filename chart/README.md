# parabol
![Version: 3.0.0-bb.3](https://img.shields.io/badge/Version-3.0.0--bb.3-informational?style=flat-square) ![AppVersion: 10.3.3](https://img.shields.io/badge/AppVersion-10.3.3-informational?style=flat-square)

A Helm chart to deploy redis, postgres, and parabol containers.

## Deploying the Helm Chart with Custom Values

This README provides guidance on how to deploy a Helm chart using the provided `values.yaml` file, upgrade the deployed chart, and uninstall the release.

### Prerequisites

1. Ensure Helm is installed. If not, you can install Helm by following the official documentation: [Installing Helm](https://helm.sh/docs/intro/install/).
2. Kubernetes cluster setup and `kubectl` installed.
3. Access to the specified image registry. Ensure you have permissions to pull images.

### Minimum Resource Requirements

Each Parabol deployment may require differing CPU, RAM, and storage requirements based upon the number of users and intensity of usage. From experience here are the minimums we suggest to support an installation supporting 10 to 1,000 users. The following assumes the higher end of 1,000 users with the tech stack consisting of Parabol, Postgres, and Redis running in Kubernetes (for physical or virtual machines adjust accordingly to match).

``` yaml
CPU and Memory:
    Parabol
        limits:
          cpu: 2
          memory: 12Gi
        requests:
          cpu: 1
          memory: 6Gi
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
    Redis PVC: minimum 500Mi
    Postgres PVC: minimum 3Gi
```

### Changing Resource Allocation

By default Parabol is deployed without minimum allocations for cpu and memory. To change the resources configurations allocated to Parabol, add the above yaml to the `resources` section within the values file for each deployment (parabol, redis, or postgres). Add at least the minimums from the `Minimum Resource Requirements` above and re-deploy the helm chart.

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

The provided `values.yaml` contains configurations for deploying services like Redis, PostgreSQL, and Parabol. Here's a brief explanation:

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
| global.imageRegistry.createSecret | bool | `false` | Create imagepullsecret with deployment template (must use dockerconfigjson for auth credentials) |
| global.imageRegistry.host | string | `"registry1.dso.mil"` | Container registry hostname |
| global.imageRegistry.imagePullSecrets | list | `[{"name":"regcred"}]` | Secret needed to pull images from registry (must be created in namespace prior or enabled above) # imagePullSecrets: #   - name: mySecretName |
| ingress.enabled | bool | `true` | Enables external routing to Parabol service via Istio |
| ingress.gateway | object | `{"create":false}` | Create additional istio gateway resource if needed |
| ingress.gateways | list | `["istio-system/public"]` | Istio gateway that should be used for routing ex. gateways:       - istio-system/public |
| ingress.hostname | string | `"parabol.dev.bigbang.mil"` | The external hostname for Parabol application |
| monitoring.dashboards.label | string | `"grafana_dashboard"` | Grafana dashboard labels to check |
| monitoring.dashboards.namespace | string | `"monitoring"` | K8s namespace where the monitoring stack is deployed |
| monitoring.enabled | bool | `true` | Enable BigBang Monitoring resources |
| monitoring.postgres.env[0] | object | `{"name":"DATA_SOURCE_NAME","value":"postgresql://postgres:parabol@localhost:5432/parabol?sslmode=disable"}` | Postgres exporter env vars |
| monitoring.postgres.metricsPort | int | `9187` | Port that Postgres metrics are exposed on |
| monitoring.redis.metricsPort | int | `9121` | Port that Redis metrics are exposed on |
| parabolDeployment.env.authGooleDisabled | bool | `true` | Flag indicating if Google authentication is disabled ("true" or "false"). |
| parabolDeployment.env.authInternalDisabled | bool | `false` | Flag indicating if internal username/password authentication is disabled ("true" or "false"). |
| parabolDeployment.env.authMicrosoftDisabled | bool | `true` | Flag indicating if Microsoft authentication is disabled ("true" or "false"). |
| parabolDeployment.env.authSsoDisabled | bool | `false` | Flag indicating if Single Sign-On (SSO) authentication is disabled ("true" or "false"). |
| parabolDeployment.env.awsAccessKeyId | string | `"key_AWS_ACCESS_KEY_ID"` | AWS S3 configuration for static assets |
| parabolDeployment.env.awsRegion | string | `"key_AWS_REGION"` |  |
| parabolDeployment.env.awsS3Bucket | string | `"BUCKET_NAME"` |  |
| parabolDeployment.env.awsSecretAccessKey | string | `"key_AWS_SECRET_ACCESS_KEY"` |  |
| parabolDeployment.env.cdnBaseUrl | string | `""` | Base url for static assets |
| parabolDeployment.env.chronosAutoPause | string | `"0 0 5 * * *"` |  |
| parabolDeployment.env.chronosBatchEmails | string | `"0 0 10 * * *"` |  |
| parabolDeployment.env.chronosProcessRecurrence | string | `"0 */5 * * * *"` |  |
| parabolDeployment.env.chronosScheduleJobs | string | `"0 */10 * * * *"` | Chronos configuration |
| parabolDeployment.env.chronosUpdateTokens | string | `"0 0 0 1,15 * *"` |  |
| parabolDeployment.env.fileStoreProvider | string | `"local"` | fileStoreProvider: Specifies the provider for file storage - local | s3 |
| parabolDeployment.env.gifProvider | string | `"tenor"` | gif image provider ( tenor, gifabol, empty string to hide gif search) |
| parabolDeployment.env.globalBannerBgColor | string | `"#007a33"` |  |
| parabolDeployment.env.globalBannerColor | string | `"#FFFFFF"` |  |
| parabolDeployment.env.globalBannerEnabled | string | `"true"` | CUI Banner configuration |
| parabolDeployment.env.globalBannerText | string | `"UNCLASSIFIED NOT APPROVED FOR CUI (IL-2)"` |  |
| parabolDeployment.env.goocleCloudPrivateKey | string | `"key_GOOGLE_CLOUD_PRIVATE_KEY"` | Google Service Account Private key (optional variable for use with GCP service account credential) |
| parabolDeployment.env.goocleCloudPrivateKeyId | string | `"key_GOOGLE_CLOUD_PRIVATE_KEY_ID"` | Google Private Key ID (optional variable for use with GCP service account credential) |
| parabolDeployment.env.googleCloudClientEmail | string | `"key_GOOGLE_CLOUD_CLIENT_EMAIL"` | Google Service Account Email (optional variable if Google services are used) |
| parabolDeployment.env.hocusPocusPort | int | `3003` | Websocket port for Pages support |
| parabolDeployment.env.host | string | `"parabol.dev.bigbang.mil"` | The external hostname for Parabol application |
| parabolDeployment.env.invitationShortlink | string | `"parabol.dev.bigbang.mil/invitation-link"` | The base URL used to construct invitation shortlinks. |
| parabolDeployment.env.isEnterprise | bool | `true` | Flag indicating if the default tier for the instance is Enterprise. Use this for privately managed instances to make all new orgs, teams, and users enterprise tier. This flag is implemented in 7.2.0 or greater. |
| parabolDeployment.env.mailFrom | string | `"key_MAIL_FROM"` |  |
| parabolDeployment.env.mailProvider | string | `"smtp"` | SMTP configuration |
| parabolDeployment.env.mailSmtpHost | string | `"key_MAIL_SMTP_HOST"` |  |
| parabolDeployment.env.mailSmtpPassword | string | `"key_MAIL_SMTP_PASSWORD"` |  |
| parabolDeployment.env.mailSmtpPort | string | `"587"` |  |
| parabolDeployment.env.mailSmtpUseTls | string | `"1"` |  |
| parabolDeployment.env.mailSmtpUser | string | `"key_MAIL_SMTP_USER"` |  |
| parabolDeployment.env.mailsmtpCiphers | string | `"HIGH:MEDIUM:!aNULL:!eNULL:@STRENGTH:!DH:!kEDH"` |  |
| parabolDeployment.env.mailSmtpURL | string | `smtps://username:password@smtp.example.com/?pool=true&tls.rejectUnauthorized=false&tls.ignoreTLS=false` |  |
| parabolDeployment.env.mailSmtpDebug | string | `"true"` |  |
| parabolDeployment.env.mattermost | object | `{"enabled":true,"instanceUrl":"https://mattermost.example.com","mattermostSecret":"MATTERMOST_SECRET"}` | Mattermost Plugin integration |
| parabolDeployment.env.mattermost.enabled | bool | `true` | Create mattermost plugin secret |
| parabolDeployment.env.mattermost.instanceUrl | string | `"https://mattermost.example.com"` | Mattermost instance URL |
| parabolDeployment.env.mattermost.mattermostSecret | string | `"MATTERMOST_SECRET"` | Mattermost plugin secret |
| parabolDeployment.env.port | int | `3000` | The port on which the application will be exposed. |
| parabolDeployment.env.protocol | string | `"https"` | The protocol used by the server ("http" or "https"). |
| parabolDeployment.env.redisUrl | string | `"redis://redis-service.parabol.svc.cluster.local:6379"` | The URL used to access the Redis server. |
| parabolDeployment.env.samlIssuer | string | `""` | SAML Issuer (Override default issuer client with this value) |
| parabolDeployment.env.serverSecret | string | `"QmtzUGVRUXJSa1hoRHJ1Z3pRRGc1TncK"` | The secret key used to generate JWT tokens |
| parabolDeployment.env.tenorSecret | string | `""` | Tenor API key for gif search |
| registryCredentials.password | string | `nil` |  |
| registryCredentials.username | string | `nil` | Username / password auth container registry |
| services.parabol.affinity | object | `{}` |  |
| services.parabol.annotations | object | `{}` | Pod annotations |
| services.parabol.defaultIDP | bool | `false` | Determines if there is a default IDP configure change to true to enable |
| services.parabol.env.postgresHost | string | `"postgres-service"` | Parabol config to reach Postgresql |
| services.parabol.env.redisHost | string | `"redis-service"` | Parabol config to reach Redis |
| services.parabol.ffGqlEndpoint | string | `"https://parabol.dev.bigbang.mil/intranet-graphql"` | Parabol graphql endpoint |
| services.parabol.ffInsights | bool | `false` | Determines if usage stats/insights is enabled, change to true to enable |
| services.parabol.ffInsightsDomain | string | `"parabol.dev.bigbang.mil"` | Parabol domains to be whitelisted for usage stats/insights |
| services.parabol.ffInsightsEmailsDb | string | `"admin@parabol.dev.bigbang.mil"` | Parabol user emails that can view usuage stats/insights |
| services.parabol.ffInsightsToken | string | `"your_long_lived_token"` | Parabol long lived token that is generated from server secret |
| services.parabol.idp_host | string | `"parabol.dev.bigbang.mil"` | Parabol hostname |
| services.parabol.idp_stub | string | `"bigbang"` | This is the unique ID for the SAML entry in DB |
| services.parabol.idp_url | string | `"https://fqdn.to.idp.dev.bigbang.mil"` | IDP URL from SAML SP |
| services.parabol.image | string | `"ironbank/parabol/parabol:10.3.3"` | Image to use for deploying Parabol |
| services.parabol.livenessProbe | list | `[]` |  |
| services.parabol.localStorage.accessModes[0] | string | `"ReadWriteMany"` |  |
| services.parabol.localStorage.awsEbs | bool | `true` |  |
| services.parabol.localStorage.driver | string | `"efs.csi.aws.com"` | CSI Driver |
| services.parabol.localStorage.efsId | string | `"example"` |  |
| services.parabol.localStorage.enabled | bool | `true` | Attach volume for local storage |
| services.parabol.localStorage.storage | string | `"5Gi"` | Size of PVC volume used |
| services.parabol.localStorage.storageClassName | string | `"efs-sc"` | Storage Class used (efs-sc, local-path) |
| services.parabol.nodeSelector | object | `{}` | Pod spec for adding node constraints |
| services.parabol.ports.external | int | `80` | Exposed port for Parabol to run external to cluster |
| services.parabol.ports.internal | int | `3000` | Exposed port for Parabol to run internal to cluster |
| services.parabol.readinessProbe.failureThreshold | int | `3` | How many time should the check fail before restarting |
| services.parabol.readinessProbe.httpGet.path | string | `"/ready"` | Path to HTTP check |
| services.parabol.readinessProbe.httpGet.port | int | `3000` | Port for HTTP check |
| services.parabol.readinessProbe.initialDelaySeconds | int | `30` | Delay before checking for readiness |
| services.parabol.readinessProbe.periodSeconds | int | `10` | The amount of time to check for |
| services.parabol.readinessProbe.successThreshold | int | `1` | How many successes should the check have before ready |
| services.parabol.readinessProbe.timeoutSeconds | int | `1` | How long before the check timesout |
| services.parabol.replicas | int | `1` | Number of replicas to deploy |
| services.parabol.resources | object | `{"limits":{"memory":"3Gi"},"requests":{"cpu":"1000m","memory":"3Gi"}}` | Container resource requests and limits |
| services.parabol.startupProbe | list | `[]` |  |
| services.parabol.tolerations | list | `[]` |  |
| services.postgres.affinity | object | `{}` |  |
| services.postgres.annotations | object | `{}` | Pod annotations |
| services.postgres.backups.enabled | bool | `false` | Enable automatic backups |
| services.postgres.backups.restore | bool | `false` | Enable restore job from last backup |
| services.postgres.backups.schedule | string | `"0 2 * * *"` | Schedule for backup jobs example - run every day at 3am |
| services.postgres.backups.volumeSize | string | `"10Gi"` | Size of PVC volume used |
| services.postgres.enabled | bool | `true` | Deploy Postgres pods - Disable if using external postgres instance |
| services.postgres.exporter | string | `"ironbank/opensource/prometheus/postgres-exporter:v0.13.2"` | Image to use for deploying Postgres exporter for monitoring |
| services.postgres.image | string | `"ironbank/opensource/postgres/postgresql:16.2"` | Image to use for deploying PostgreSql |
| services.postgres.localStorage.enabled | bool | `true` | Use PersistentVolumeClaim for Postgres storage |
| services.postgres.localStorage.volumeSize | string | `"10Gi"` | Size of PVC volume used |
| services.postgres.nodeSelector | object | `{}` | Pod spec for adding node constraints |
| services.postgres.resources | object | `{}` | Container resource requests and limits |
| services.postgres.tolerations | list | `[]` |  |
| services.redis.affinity | object | `{}` |  |
| services.redis.allowPrivilegeEscalation | bool | `false` |  |
| services.redis.annotations | object | `{}` | Pod annotations |
| services.redis.exporter | string | `"ironbank/bitnami/analytics/redis-exporter:v1.54.0"` | Image to use for deploying Redis exporter for monitoring |
| services.redis.fsGroup | int | `1000` | securityContext settings |
| services.redis.image | string | `"ironbank/opensource/redis/redis8:8.2.2` | Image to use for deploying Redis |
| services.redis.nodeSelector | object | `{}` | Pod spec for adding node constraints |
| services.redis.resources | object | `{}` | resource requests and limits |
| services.redis.runAsGroup | int | `1000` |  |
| services.redis.runAsNonRoot | bool | `true` |  |
| services.redis.runAsUser | int | `999` |  |
| services.redis.tolerations | list | `[]` |  |

----------------------------------------------

## Security Notes

It's essential to treat the `values.yaml` file with care, especially if it contains sensitive data like passwords. Avoid committing the file with actual passwords to version control systems. Instead, consider using Helm secrets or Kubernetes secrets to manage sensitive values.

## Configuration Notes

You will have to update `dockerconfigjson` and `registryCredentials.username & registryCredentials.password` in your values file with proper registry information.

### SuperUsers
Superusers have the ability to run mutations and advanced configuration within Parabol

To add superuser permissions to an existing user:
- shell into the webserver container for the currently running Parabol deployment
- run the `assignSURole.js` script
```
node ./assignSURole.js -a <users_email_address>
```
- You will see console output for the added user

### CUI Banner
To enable / disable and configure the CUI banner for Parabol deployments, the following env vars will need to be set
``` plain
# GLOBAL BANNER
GLOBAL_BANNER_ENABLED='true'
GLOBAL_BANNER_TEXT='UNCLASSIFIED NOT APPROVED FOR CUI (IL-2)'
GLOBAL_BANNER_BG_COLOR='#007a33'
GLOBAL_BANNER_COLOR='#FFFFFF'
```

### SSO

#### SAML - Allow all domains within single instance

Admins can use a single SAML record for the entire instance if SSO is the only way to log in to the app & a SAML record already exists. To set up SAML, they can temporarily enable email/password auth & then after it's set up successfully they can disable that.

The following env vars must be set to the exact values below to enable this:

``` plain
AUTH_INTERNAL_DISABLED = 'true'
AUTH_GOOGLE_DISABLED = 'true'
AUTH_MICROSOFT_DISABLED = 'true'
AUTH_SSO_DISABLED = 'false'
```
### Integrations
Please see the [Integrations](./chart/docs/integrations.md) documentation
