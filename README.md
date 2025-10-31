<!-- Warning: Do not manually edit this file. See notes on gluon + helm-docs at the end of this file for more information. -->
# parabol

![Version: 3.9.2](https://img.shields.io/badge/Version-3.9.2-informational?style=flat-square) ![AppVersion: 10.31.0](https://img.shields.io/badge/AppVersion-10.31.0-informational?style=flat-square) ![Maintenance Track: bb_community](https://img.shields.io/badge/Maintenance_Track-bb_community-red?style=flat-square)

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
| services.redis.image | string | `"ironbank/opensource/redis/redis8:8.2.2"` | Image to use for deploying Redis |
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
| services.postgres.image | string | `"ironbank/opensource/postgres/postgresql:16.2"` | Image to use for deploying PostgreSql |
| services.postgres.exporter | string | `"ironbank/opensource/prometheus/postgres-exporter:v0.13.2"` | Image to use for deploying Postgres exporter for monitoring |
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
| services.parabol.image | string | `"ironbank/parabol/parabol:10.29.0"` | Image to use for deploying Parabol |
| services.parabol.defaultIDP | bool | `false` | Determines if there is a default IDP configure change to true to enable |
| services.parabol.idp_stub | string | `"bigbang"` | This is the unique ID for the SAML entry in DB |
| services.parabol.idp_url | string | `"https://fqdn.to.idp.dev.bigbang.mil"` | IDP URL from SAML SP |
| services.parabol.idp_host | string | `"parabol.dev.bigbang.mil"` | Parabol hostname |
| services.parabol.ffGqlEndpoint | string | `"https://parabol.dev.bigbang.mil/intranet-graphql"` | Parabol graphql endpoint |
| services.parabol.ffInsights | bool | `false` | Determines if usage stats/insights is enabled, change to true to enable |
| services.parabol.ffInsightsToken | string | `"your_long_lived_token"` | Parabol long lived token that is generated from server secret |
| services.parabol.ffInsightsEmailsDb | string | `"admin@parabol.dev.bigbang.mil"` | Parabol user emails that can view usuage stats/insights |
| services.parabol.ffInsightsDomain | string | `"parabol.dev.bigbang.mil"` | Parabol domains to be whitelisted for usage stats/insights |
| services.parabol.replicas | int | `1` | Number of replicas to deploy |
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
| services.parabol.resources | object | `{"limits":{"memory":"3Gi"},"requests":{"cpu":"1000m","memory":"3Gi"}}` | Container resource requests and limits |
| services.parabol.nodeSelector | object | `{}` | Pod spec for adding node constraints |
| services.parabol.affinity | object | `{}` |  |
| services.parabol.tolerations | list | `[]` |  |
| services.parabol.annotations | object | `{}` | Pod annotations |
| services.parabol.livenessProbe | list | `[]` |  |
| services.parabol.readinessProbe.initialDelaySeconds | int | `30` | Delay before checking for readiness |
| services.parabol.readinessProbe.periodSeconds | int | `10` | The amount of time to check for |
| services.parabol.readinessProbe.timeoutSeconds | int | `1` | How long before the check timesout |
| services.parabol.readinessProbe.failureThreshold | int | `3` | How many time should the check fail before restarting |
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
| ingress.gateways | list | `["istio-system/public"]` | Istio gateway that should be used for routing ex. gateways:       - istio-system/public |
| parabolDeployment.env.fileStoreProvider | string | `"local"` | fileStoreProvider: Specifies the provider for file storage - local | s3 |
| parabolDeployment.env.cdnBaseUrl | string | `""` | Base url for static assets |
| parabolDeployment.env.port | int | `3000` | The port on which the application will be exposed. |
| parabolDeployment.env.hocusPocusPort | int | `3003` | Websocket port for Pages support |
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

