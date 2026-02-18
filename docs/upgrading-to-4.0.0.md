# Upgrading to 4.0.0

## Pre upgrade:
- Make sure to be running in the latest 3.x version. If not, upgrade to the latest 3.x version first.
- Backup the Postgres database. Specially if databases are deployed through this Helm chart.
- Backup the static files in the folder `self-hosted`, if Parabol is deployed using `FILESTORE_PROVIDER='local'`. To do so, you can use `kubectl cp <namespace>/<pod-name>:/home/node/parabol/self-hosted ./backup-folder`.

## Upgrade:

> **There will be a small downtime while Postgres is updated.**

- If a PersistentVolumeClaim is used for the `self-hosted` folder (when `FILESTORE_PROVIDER='local'`), its configuration must be adapted to allow multiple Web Servers and the Pre-Deploy job to write to it. Please review carefully this configuration before applying any changes.
- Adapt the number of Web Servers if wished, using `services.parabol.replicas` to add redundancy. It's recommended to run with three web servers to have zero-downtime upgrades and allow node upgrades without downtime. 
- Upgrade from the latest 3.x version to 4.0.0. 
  -  Pre-Deploy will run as a pre-upgrade hook.
  - Application version is unchanged.
  - Postgres image changes to use pgvector16:0.8.0, adding pgvector support, required for Parabol Search to work. 
    