# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [4.0.1] - 2026-03-06
### Changed
- Nginx listen and container ports configurable via `values.yaml`.

## [4.0.0] - 2025-12-16
### Breaking changes !!!
> **Please read the document upgrading-to-4.0.0.md for more information.**
- Default `ingress.gateways` is set now to `["istio-gateway/public-ingressgateway"]` which is the default istio-gateway available when Big Bang is deployed.
- PreDeploy script is running as a Helm hook (Job) on upgrades. On first install, the job is run without any hook.
- Storage must support writing from multiple pods. PreDeploy must have access to the same storage as any of the web servers.
- Web Server deployment stragegy is set to `RollingUpdate` with `maxSurge: 100%` and `maxUnavailable: 0%`.
- PostgreSQL image changed to pgvector16:0.8.0 to support Parabol Search.

### Changed
- Predeploy running as a job hook on upgrades.
- Web Server can scale to multiple replicas.
- Text Embeddings Inference added but disabled by default.
- Embedder added but disabled by default.
- Nginx proxy to serve assets, depending on the filestore configuration, added but disabled by default.
- Documentation on Parabol Search, serving assets and upgrading to 4.0.0.
- PostgreSQL image changed to support Parabol Search.

## [3.13.0] - 2026-02-09
### Changed
- AppVersion to v12.0.0

## [3.12.0] - 2026-01-15
### Changed
- AppVersion to v11.6.0

## [3.11.0] - 2025-12-16
### Changed
- Support ext volumes

## [3.10.2] - 2025-12-15
### Changed
- AppVersion to v11.4.0
- Support Audit Logs


## [3.10.1] - 2025-11-21
### Changed (https://keepachangelog.com/en/1.0.0/#how)
- AppVersion to 10.34.1 (update values.yaml)

## [3.10.0] - 2025-11-21
### Changed (https://keepachangelog.com/en/1.0.0/#how)
- AppVersion to 10.34.1

## [3.9.3] - 2025-11-10
### Changed (https://keepachangelog.com/en/1.0.0/#how)
- Fix values.yaml version

## [3.9.2] - 2025-10-29
### Changed (https://keepachangelog.com/en/1.0.0/#how)
- AppVersion to 10.31.0

## [3.9.1] - 2025-10-23
### Changed (https://keepachangelog.com/en/1.0.0/#how)
- New CI pipeline
- AppVersion to 10.29.0


## [3.9.0-bb.3] - 2025-10-22
### Changed (https://keepachangelog.com/en/1.0.0/#how)
- Improve CI
- AppVersion to 10.28.1

## [3.8.0] - 2025-10-16
### Changed (https://keepachangelog.com/en/1.0.0/#how)
- AppVersion to 10.27.6
