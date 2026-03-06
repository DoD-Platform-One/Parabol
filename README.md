<!-- Warning: Do not manually edit this file. See notes on gluon + helm-docs at the end of this file for more information. -->
# parabol

![Version: 4.0.1](https://img.shields.io/badge/Version-4.0.1-informational?style=flat-square) ![AppVersion: 12.0.0](https://img.shields.io/badge/AppVersion-12.0.0-informational?style=flat-square) ![Maintenance Track: bb_community](https://img.shields.io/badge/Maintenance_Track-bb_community-red?style=flat-square)

A Helm chart to deploy Redis, Postgres, and Parabol containers.

## Upstream Release Notes

- [Find upstream chart's release notes and CHANGELOG here](https://github.com/ParabolInc/parabol/tree/master/packages/client/components)

## Learn More

- [Application Overview](docs/overview.md)
- [Other Documentation](docs/)

## Pre-Requisites

- Kubernetes Cluster deployed
- Kubernetes config installed in `~/.kube/config`
- Helm installed

Install Helm

https://helm.sh/docs/intro/install/

## Deployment

- Clone down the repository
- cd into directory

```bash
helm install parabol chart/
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.imageRegistry.host | string | `"registry1.dso.mil"` | Container registry hostname |
| global.imageRegistry.createSecret | bool | `false` | Create imagepullsecret with deployment template (must use dockerconfigjson for auth credentials) |
| global.imageRegistry.imagePullSecrets | list | `[{"name":"regcred"}]` | Secret needed to pull images from registry (must be created in namespace prior or enabled above) # imagePullSecrets: #   - name: mySecretName |
| registryCredentials.username | string | `nil` | Username / password auth container registry |
| registryCredentials.password | string | `nil` |  |
| services.redis.enabled | bool | `true` | Deploy Redis pods - Disable if using external redis instance |
| services.redis.image | string | `"ironbank/opensource/redis/redis8"` | Image to use for deploying Redis |
| services.redis.imageTag | string | `"8.2.2"` | Tag of the Redis image |
| services.redis.exporter | string | `"ironbank/bitnami/analytics/redis-exporter:v1.54.0"` | Image to use for deploying Redis exporter for monitoring |
| services.redis.resources | object | `{}` | resource requests and limits |
| services.redis.nodeSelector | object | `{}` | Pod spec for adding node constraints |
| services.redis.affinity | object | `{}` |  |
| services.redis.tolerations | list | `[]` |  |
| services.redis.annotations | object | `{}` | Pod annotations |
| services.redis.fsGroup | int | `1000` | securityContext settings |
| services.redis.runAsUser | int | `999` |  |
| services.redis.runAsGroup | int | `1000` |  |
| services.redis.runAsNonRoot | bool | `true` |  |
| services.redis.allowPrivilegeEscalation | bool | `false` |  |
| services.postgres.enabled | bool | `true` | Deploy Postgres pods - Disable if using external postgres instance |
| services.postgres.image | string | `"ironbank/opensource/pgvector/pgvector16"` | Image to use for deploying PostgreSql |
| services.postgres.imageTag | string | `"0.8.0"` | Tag of the PostgreSql image |
| services.postgres.exporter | string | `"ironbank/opensource/prometheus/postgres-exporter:v0.19.0"` | Image to use for deploying Postgres exporter for monitoring |
| services.postgres.localStorage.enabled | bool | `true` | Use PersistentVolumeClaim for Postgres storage |
| services.postgres.localStorage.volumeSize | string | `"10Gi"` | Size of PVC volume used |
| services.postgres.backups.enabled | bool | `false` | Enable automatic backups |
| services.postgres.backups.schedule | string | `"0 2 * * *"` | Schedule for backup jobs example - run every day at 3am |
| services.postgres.backups.volumeSize | string | `"10Gi"` | Size of PVC volume used |
| services.postgres.backups.restore | bool | `false` | Enable restore job from last backup |
| services.postgres.resources | object | `{}` | Container resource requests and limits |
| services.postgres.nodeSelector | object | `{}` | Pod spec for adding node constraints |
| services.postgres.affinity | object | `{}` |  |
| services.postgres.tolerations | list | `[]` |  |
| services.postgres.annotations | object | `{}` | Pod annotations |
| services.parabol.image | string | `"ironbank/parabol/parabol"` | Image to use for deploying Parabol |
| services.parabol.version | string | `""` | Custom version of the Parabol container image -  defaults to AppVersion |
| services.parabol.defaultIDP | bool | `false` | Determines if there is a default IDP configure change to true to enable |
| services.parabol.idp_stub | string | `"bigbang"` | This is the unique ID for the SAML entry in DB |
| services.parabol.idp_url | string | `"https://fqdn.to.idp.dev.bigbang.mil"` | IDP URL from SAML SP |
| services.parabol.idp_host | string | `"parabol.dev.bigbang.mil"` | Parabol hostname |
| services.parabol.ffGqlEndpoint | string | `"https://parabol.dev.bigbang.mil/intranet-graphql"` | Parabol graphql endpoint |
| services.parabol.ffInsights | bool | `false` | Determines if usage stats/insights is enabled, change to true to enable |
| services.parabol.ffInsightsToken | string | `"your_long_lived_token"` | Parabol long lived token that is generated from server secret |
| services.parabol.ffInsightsEmailsDb | string | `"admin@parabol.dev.bigbang.mil"` | Parabol user emails that can view usuage stats/insights |
| services.parabol.ffInsightsDomain | string | `"parabol.dev.bigbang.mil"` | Parabol domains to be whitelisted for usage stats/insights |
| services.parabol.replicas | int | `1` | Number of web server replicas |
| services.parabol.env.redisHost | string | `"redis-service"` | Parabol config to reach Redis |
| services.parabol.env.postgresHost | string | `"postgres-service"` | Parabol config to reach Postgresql |
| services.parabol.ports.internal | int | `3000` | Exposed port for Parabol to run internal to cluster |
| services.parabol.ports.external | int | `80` | Exposed port for Parabol to run external to cluster |
| services.parabol.localStorage.enabled | bool | `true` | Attach volume for local storage |
| services.parabol.localStorage.awsEbs | bool | `true` |  |
| services.parabol.localStorage.storage | string | `"5Gi"` | Size of PVC volume used |
| services.parabol.localStorage.storageClassName | string | `"efs-sc"` | Storage Class used (efs-sc, local-path) |
| services.parabol.localStorage.accessModes[0] | string | `"ReadWriteMany"` |  |
| services.parabol.localStorage.driver | string | `"efs.csi.aws.com"` | CSI Driver |
| services.parabol.localStorage.efsId | string | `"example"` |  |
| services.parabol.extraVolumes | list | `[]` | Extra volumes to add to all Parabol pods |
| services.parabol.extraVolumeMounts | list | `[]` |  |
| services.parabol.resources | object | `{"limits":{"memory":"3Gi"},"requests":{"cpu":"1000m","memory":"3Gi"}}` | Container resource requests and limits |
| services.parabol.nodeSelector | object | `{}` | Pod spec for adding node constraints |
| services.parabol.affinity | object | `{}` |  |
| services.parabol.tolerations | list | `[]` |  |
| services.parabol.annotations | object | `{}` | Pod annotations |
| services.parabol.serviceAccount | object | `{"annotations":{},"create":false,"extraLabels":{},"name":""}` | Service Account configuration |
| services.parabol.serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| services.parabol.serviceAccount.name | string | `""` | The name of the service account to use. If set and create is false, it will assign that name as serviceAccountName. If not set and create is true, a name is generated using the fullname template |
| services.parabol.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| services.parabol.serviceAccount.extraLabels | object | `{}` | Extra labels to add to the service account |
| services.parabol.livenessProbe | list | `[]` |  |
| services.parabol.readinessProbe.initialDelaySeconds | int | `30` | Delay before checking for readiness |
| services.parabol.readinessProbe.periodSeconds | int | `10` | The amount of time to check for |
| services.parabol.readinessProbe.timeoutSeconds | int | `1` | How long before the check timesout |
| services.parabol.readinessProbe.failureThreshold | int | `3` | How many time should the check fail before the pod is considered not ready |
| services.parabol.readinessProbe.successThreshold | int | `1` | How many successes should the check have before ready |
| services.parabol.readinessProbe.httpGet.path | string | `"/ready"` | Path to HTTP check |
| services.parabol.readinessProbe.httpGet.port | int | `3000` | Port for HTTP check |
| services.parabol.startupProbe | list | `[]` |  |
| database.env.postgresDb | string | `"parabol"` | Name of the PostgreSQL database. |
| database.env.postgresUser | string | `"postgres"` | Username to access the PostgreSQL database. |
| database.env.postgresHost | string | `"postgres-service.parabol.svc.cluster.local"` | Internal hostname used to access the PostgreSQL database. |
| database.env.postgresPort | int | `5432` | Port on which the PostgreSQL server is listening. |
| database.env.postgresPassword | string | `"parabol"` | Password to access the PostgreSQL database. |
| ingress.enabled | bool | `true` | Enables external routing to Parabol service via Istio |
| ingress.gateway | object | `{"create":false}` | Create additional istio gateway resource if needed |
| ingress.hostname | string | `"parabol.dev.bigbang.mil"` | The external hostname for Parabol application |
| ingress.gateways | list | `["istio-gateway/public-ingressgateway"]` | Istio gateway that should be used for routing ex. gateways:       - istio-gateway/public-ingressgateway |
| parabolDeployment.strategy.type | string | `"RollingUpdate"` |  |
| parabolDeployment.strategy.rollingUpdate.maxSurge | string | `"100%"` |  |
| parabolDeployment.strategy.rollingUpdate.maxUnavailable | string | `"0%"` |  |
| parabolDeployment.extraInitContainers | list | `[]` | Extra init containers to add to the parabol deployment |
| parabolDeployment.extraContainers | list | `[]` | Extra containers to add to the parabol deployment |
| parabolDeployment.nginx | object | `{"enabled":false,"existingConfigMap":"","image":{"repository":"registry1.dso.mil/ironbank/opensource/nginx/nginx-alpine","tag":"1.29.5"},"port":80,"resources":{}}` | Nginx Sidecar configuration |
| parabolDeployment.nginx.enabled | bool | `false` | Enable Nginx sidecar to serve assets |
| parabolDeployment.nginx.image | object | `{"repository":"registry1.dso.mil/ironbank/opensource/nginx/nginx-alpine","tag":"1.29.5"}` | Image to use for Nginx |
| parabolDeployment.nginx.port | int | `80` | Port on which the Nginx sidecar will listen. |
| parabolDeployment.nginx.resources | object | `{}` | Resource requests and limits for Nginx |
| parabolDeployment.nginx.existingConfigMap | string | `""` | existingConfigMap: Specifies the name of an existing ConfigMap to use for Nginx configuration. If set, the chart will not create the default nginx-config ConfigMap. |
| parabolDeployment.env.fileStoreProvider | string | `"local"` | fileStoreProvider: Specifies the provider for file storage - local | s3 |
| parabolDeployment.env.cdnBaseUrl | string | `""` | Base url for static assets |
| parabolDeployment.env.proxyCDN | bool | `false` | If true, the server signs and redirect calls from /build to the CDN. Required for PPMIs without public buckets |
| parabolDeployment.env.port | int | `3000` | The port on which the application will be exposed. |
| parabolDeployment.env.host | string | `"parabol.dev.bigbang.mil"` | The external hostname for Parabol application |
| parabolDeployment.env.protocol | string | `"https"` | The protocol used by the server ("http" or "https"). |
| parabolDeployment.env.serverSecret | string | `"QmtzUGVRUXJSa1hoRHJ1Z3pRRGc1TncK"` | The secret key used to generate JWT tokens |
| parabolDeployment.env.invitationShortlink | string | `"parabol.dev.bigbang.mil/invitation-link"` | The base URL used to construct invitation shortlinks. |
| parabolDeployment.env.redisUrl | string | `"redis://redis-service.parabol.svc.cluster.local:6379"` | The URL used to access the Redis server. |
| parabolDeployment.env.authInternalDisabled | bool | `false` | Flag indicating if internal username/password authentication is disabled ("true" or "false"). |
| parabolDeployment.env.authGooleDisabled | bool | `true` | Flag indicating if Google authentication is disabled ("true" or "false"). |
| parabolDeployment.env.authMicrosoftDisabled | bool | `true` | Flag indicating if Microsoft authentication is disabled ("true" or "false"). |
| parabolDeployment.env.authSsoDisabled | bool | `false` | Flag indicating if Single Sign-On (SSO) authentication is disabled ("true" or "false"). |
| parabolDeployment.env.isEnterprise | bool | `true` | Flag indicating if the default tier for the instance is Enterprise. Use this for privately managed instances to make all new orgs, teams, and users enterprise tier. This flag is implemented in 7.2.0 or greater. |
| parabolDeployment.env.googleCloudClientEmail | string | `"key_GOOGLE_CLOUD_CLIENT_EMAIL"` | Google Service Account Email (optional variable if Google services are used) |
| parabolDeployment.env.googleCloudPrivateKey | string | `"key_GOOGLE_CLOUD_PRIVATE_KEY"` | Google Service Account Private key (optional variable for use with GCP service account credential) |
| parabolDeployment.env.googleCloudPrivateKeyId | string | `"key_GOOGLE_CLOUD_PRIVATE_KEY_ID"` | Google Private Key ID (optional variable for use with GCP service account credential) |
| parabolDeployment.env.samlIssuer | string | `""` | SAML Issuer (Override default issuer client with this value) |
| parabolDeployment.env.gifProvider | string | `"tenor"` | gif image provider ( tenor, gifabol, empty string to hide gif search) |
| parabolDeployment.env.tenorSecret | string | `""` | Tenor API key for gif search |
| parabolDeployment.env.awsAccessKeyId | string | `"key_AWS_ACCESS_KEY_ID"` | AWS S3 configuration for static assets |
| parabolDeployment.env.awsRegion | string | `"key_AWS_REGION"` |  |
| parabolDeployment.env.awsSecretAccessKey | string | `"key_AWS_SECRET_ACCESS_KEY"` |  |
| parabolDeployment.env.awsS3Bucket | string | `"BUCKET_NAME"` |  |
| parabolDeployment.env.globalBannerEnabled | string | `"true"` | CUI Banner configuration |
| parabolDeployment.env.globalBannerText | string | `"UNCLASSIFIED NOT APPROVED FOR CUI (IL-2)"` |  |
| parabolDeployment.env.globalBannerColor | string | `"#FFFFFF"` |  |
| parabolDeployment.env.globalBannerBgColor | string | `"#007a33"` |  |
| parabolDeployment.env.mailProvider | string | `"smtp"` | SMTP configuration |
| parabolDeployment.env.mailFrom | string | `"key_MAIL_FROM"` |  |
| parabolDeployment.env.mailSmtpHost | string | `"key_MAIL_SMTP_HOST"` |  |
| parabolDeployment.env.mailSmtpPort | string | `"587"` |  |
| parabolDeployment.env.mailSmtpUser | string | `"key_MAIL_SMTP_USER"` |  |
| parabolDeployment.env.mailSmtpPassword | string | `"key_MAIL_SMTP_PASSWORD"` |  |
| parabolDeployment.env.mailSmtpUseTls | string | `"1"` |  |
| parabolDeployment.env.mailsmtpCiphers | string | `"HIGH:MEDIUM:!aNULL:!eNULL:@STRENGTH:!DH:!kEDH"` |  |
| parabolDeployment.env.mailSmtpURL | string | `""` |  |
| parabolDeployment.env.mailSmtpDebug | string | `"false"` |  |
| parabolDeployment.env.chronosScheduleJobs | string | `"0 */10 * * * *"` | Chronos configuration |
| parabolDeployment.env.chronosUpdateTokens | string | `"0 0 0 1,15 * *"` |  |
| parabolDeployment.env.chronosProcessRecurrence | string | `"0 */5 * * * *"` |  |
| parabolDeployment.env.chronosAutoPause | string | `"0 0 5 * * *"` |  |
| parabolDeployment.env.chronosBatchEmails | string | `"0 0 10 * * *"` |  |
| parabolDeployment.env.mattermost | object | `{"enabled":true,"instanceUrl":"https://mattermost.example.com","mattermostSecret":"MATTERMOST_SECRET"}` | Mattermost Plugin integration |
| parabolDeployment.env.mattermost.enabled | bool | `true` | Create mattermost plugin secret |
| parabolDeployment.env.mattermost.instanceUrl | string | `"https://mattermost.example.com"` | Mattermost instance URL |
| parabolDeployment.env.mattermost.mattermostSecret | string | `"MATTERMOST_SECRET"` | Mattermost plugin secret |
| parabolDeployment.env.auditLogs | string | `"false"` | Audit logs configuration |
| parabolDeployment.additionalEnv | list | `[]` | Environment variables for all Parabol pods |
| parabolDeployment.envFrom | list | `[]` | Environments variables from secrets and configmaps for all Parabol pods |
| preDeploy.enabled | bool | `true` | Enable or disable the pre-deploy hook (job and configMap) |
| preDeploy.job.resources | object | `{"limits":{"memory":"2Gi"},"requests":{"cpu":"500m","memory":"2Gi"}}` | Resources for the pod. Not set by default, but recommended. |
| preDeploy.job.extraLabels | object | `{}` | Labels added to both the job and the pods of pre-deploy |
| preDeploy.job.initContainers | list | `[]` | Init containers to add sidecar or any init task |
| preDeploy.job.serviceAccount | object | `{"annotations":{},"create":false,"extraLabels":{},"name":""}` | Service Account configuration |
| preDeploy.job.serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| preDeploy.job.serviceAccount.name | string | `""` | The name of the service account to use. If set and create is false, it will assign that name as serviceAccountName. If not set and create is true, a name is generated using the fullname template |
| preDeploy.job.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| preDeploy.job.serviceAccount.extraLabels | object | `{}` | Extra labels to add to the service account |
| embedder.enabled | bool | `false` | Enable or disable the Embedder |
| embedder.deployment.replicaCount | int | `1` | 1 replica by default for simplicity as it is a background stateless process |
| embedder.deployment.env | list | `[]` |  |
| embedder.deployment.envFrom | list | `[]` |  |
| embedder.deployment.livenessProbe | object | `{}` | No Liveness Probe by default |
| embedder.deployment.readinessProbe | object | `{}` | No Readiness Probe by default |
| embedder.deployment.startupProbe | object | `{}` | No Startup Probe by default |
| embedder.deployment.resources | object | `{}` | No limitation on resources by default. It is highly recommended to set them up |
| embedder.deployment.strategy.type | string | `"RollingUpdate"` |  |
| embedder.deployment.strategy.rollingUpdate | object | `{"maxSurge":"100%","maxUnavailable":"0%"}` | used only if strategy type is RollingUpdate. |
| embedder.deployment.extraLabels | object | `{}` |  |
| embedder.deployment.serviceAccount | object | `{"annotations":{},"create":false,"extraLabels":{},"name":""}` | Service Account configuration |
| embedder.deployment.serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| embedder.deployment.serviceAccount.name | string | `""` | The name of the service account to use. If set and create is false, it will assign that name as serviceAccountName. If not set and create is true, a name is generated using the fullname template |
| embedder.deployment.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| embedder.deployment.serviceAccount.extraLabels | object | `{}` | Extra labels to add to the service account |
| embedder.deployment.podAnnotations | object | `{}` |  |
| embedder.deployment.nodeSelector | object | `{}` |  |
| embedder.deployment.tolerations | list | `[]` |  |
| embedder.deployment.affinity | object | `{}` | Pod affinity @default the chart will setup default anti affinity with preferredDuringSchedulingIgnoredDuringExecution, trying to avoid ending with two pods of the same component in the same node |
| textEmbeddingsInference.enabled | bool | `false` |  |
| textEmbeddingsInference.deployment.replicaCount | int | `1` | 1 replica by default for simplicity as it is a background stateless process |
| textEmbeddingsInference.deployment.image | string | `"ironbank/parabol/text-embeddings-inference"` | Image to use for deploying text embeddings inference |
| textEmbeddingsInference.deployment.imageTag | string | `"1.8.3"` | Tag of the image |
| textEmbeddingsInference.deployment.livenessProbe | object | `{"enabled":true,"failureThreshold":3,"httpGet":{"path":"/health","port":"http","scheme":"HTTP"},"periodSeconds":30,"successThreshold":1,"timeoutSeconds":45}` | Liveness probe |
| textEmbeddingsInference.deployment.readinessProbe | object | `{"enabled":false,"failureThreshold":3,"httpGet":{"path":"/health","port":"http","scheme":"HTTP"},"periodSeconds":30,"successThreshold":1,"timeoutSeconds":10}` | Readiness probe |
| textEmbeddingsInference.deployment.readinessProbe.enabled | bool | `false` | Disabled by default. |
| textEmbeddingsInference.deployment.startupProbe | object | `{"enabled":true,"failureThreshold":6,"httpGet":{"path":"/health","port":"http","scheme":"HTTP"},"initialDelaySeconds":90,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":10}` | startupProbe enabled by default |
| textEmbeddingsInference.deployment.resources | object | `{}` | No limitation on resources by default. It is highly recommended to set them up |
| textEmbeddingsInference.deployment.strategy.type | string | `"RollingUpdate"` |  |
| textEmbeddingsInference.deployment.strategy.rollingUpdate | object | `{"maxSurge":"100%","maxUnavailable":"0%"}` | used only if strategy type is RollingUpdate. |
| textEmbeddingsInference.deployment.extraLabels | object | `{}` |  |
| textEmbeddingsInference.deployment.serviceAccount | object | `{"annotations":{},"create":false,"extraLabels":{},"name":""}` | Service Account configuration |
| textEmbeddingsInference.deployment.serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| textEmbeddingsInference.deployment.serviceAccount.name | string | `""` | The name of the service account to use. If set and create is false, it will assign that name as serviceAccountName. If not set and create is true, a name is generated using the fullname template |
| textEmbeddingsInference.deployment.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| textEmbeddingsInference.deployment.serviceAccount.extraLabels | object | `{}` | Extra labels to add to the service account |
| textEmbeddingsInference.deployment.podAnnotations | object | `{}` |  |
| textEmbeddingsInference.deployment.nodeSelector | object | `{}` |  |
| textEmbeddingsInference.deployment.tolerations | list | `[]` |  |
| textEmbeddingsInference.deployment.affinity | object | `{}` | Pod affinity @default the chart will setup default anti affinity with preferredDuringSchedulingIgnoredDuringExecution, trying to avoid ending with two pods of the same component in the same node |
| textEmbeddingsInference.deployment.volumes | list | `[]` |  |
| textEmbeddingsInference.deployment.volumeMounts | list | `[]` |  |
| textEmbeddingsInference.deployment.command | list | `[]` | Command to override container entrypoint |
| textEmbeddingsInference.deployment.args | list | `[]` | Arguments to pass to the command |
| textEmbeddingsInference.deployment.env[0].name | string | `"MODEL_ID"` |  |
| textEmbeddingsInference.deployment.env[0].value | string | `"Svenni551/Qwen3-Embedding-0.6B-ONNX-INT8"` |  |
| textEmbeddingsInference.deployment.env[1].name | string | `"AUTO_TRUNCATE"` |  |
| textEmbeddingsInference.deployment.env[1].value | string | `"true"` |  |
| textEmbeddingsInference.deployment.env[2].name | string | `"MAX_BATCH_TOKENS"` |  |
| textEmbeddingsInference.deployment.env[2].value | string | `"2048"` |  |
| textEmbeddingsInference.deployment.env[3].name | string | `"MAX_CLIENT_BATCH_SIZE"` |  |
| textEmbeddingsInference.deployment.env[3].value | string | `"8"` |  |
| textEmbeddingsInference.deployment.env[4].name | string | `"POOLING"` |  |
| textEmbeddingsInference.deployment.env[4].value | string | `"mean"` |  |
| textEmbeddingsInference.deployment.envFrom | list | `[]` |  |
| textEmbeddingsInference.deployment.initContainers | list | `[]` |  |
| monitoring.enabled | bool | `true` | Enable BigBang Monitoring resources |
| monitoring.dashboards.namespace | string | `"monitoring"` | K8s namespace where the monitoring stack is deployed |
| monitoring.dashboards.label | string | `"grafana_dashboard"` | Grafana dashboard labels to check |
| monitoring.redis.metricsPort | int | `9121` | Port that Redis metrics are exposed on |
| monitoring.postgres.metricsPort | int | `9187` | Port that Postgres metrics are exposed on |
| monitoring.postgres.env[0] | object | `{"name":"DATA_SOURCE_NAME","value":"postgresql://postgres:parabol@localhost:5432/parabol?sslmode=disable"}` | Postgres exporter env vars |
| grafana.enabled | bool | `true` |  |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.

---

_This file is programatically generated using `helm-docs` and some BigBang-specific templates. The `gluon` repository has [instructions for regenerating package READMEs](https://repo1.dso.mil/big-bang/product/packages/gluon/-/blob/master/docs/bb-package-readme.md)._

