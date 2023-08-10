# cronjobs

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Kubernetes Cron Jobs

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../k8s-common | k8s-common | 2.0.0   |

## Parameters

### Global parameters

| Name                      | Description                                          | Value          |
| ------------------------- | ---------------------------------------------------- | -------------- |
| `global.org`              | Company Organization Unit(product group).            | `""`           |
| `global.serviceName`      | Name of the service. Affects public DNS.             | `""`           |
| `global.production`       | Will the service run in production environment       | `false`        |
| `global.environmentName`  | Name of the environment, user-specified.             | `dev`          |
| `global.image.name`       | Name of the image,                                   | `""`           |
| `global.image.tag`        | Tag of the image                                     | `latest`       |
| `global.image.pullPolicy` | The default pull policy is IfNotPresent which causes | `IfNotPresent` |


### Common parameters

| Name                        | Description                                                                               | Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `nameOverride`              | By default, name uses '{{ .Chart.Name }}'.                                                | `""`   |
| `fullnameOverride`          | By default, fullname uses '{{ .Release.Name }}-{{ .Chart.Name }}'.                        | `""`   |
| `podSecurityContext`        | Pod security context                                                                      | `{}`   |
| `securityContext`           | Security context for the container                                                        | `{}`   |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}`   |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]`   |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`   |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft` |
| `nodeAffinityPreset`        | Node affinity preset                                                                      |        |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`   |
| `nodeAffinityPreset.key`    | Node label key to match Ignored if `affinity` is set.                                     | `""`   |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`   |
| `affinity`                  | Affinity for pod assignment                                                               | `{}`   |


### Configure Service Accounts for Pod

| Name                         | Description                                           | Value   |
| ---------------------------- | ----------------------------------------------------- | ------- |
| `serviceAccount.create`      | Specifies whether a service account should be created | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account             | `{}`    |
| `serviceAccount.name`        | The name of the service account to use.               | `""`    |


### Environment variables that get added to the container

| Name              | Description                                                             | Value |
| ----------------- | ----------------------------------------------------------------------- | ----- |
| `env.values`      | generic Environment variables that get added to the container           | `{}`  |
| `env.refs`        | Environment variables as references to the pod                          | `{}`  |
| `env.configmap`   | Environment variables that get added to the container from ConfigMap    | `{}`  |
| `env.secret`      | Kubernetes secrets that get added to the container                      | `{}`  |
| `env.vaultSecret` | Kubernetes secrets that get added to the container from Hashicorp Vault | `{}`  |


### Container resource requests and limits

| Name                 | Description                              | Value |
| -------------------- | ---------------------------------------- | ----- |
| `resources.limits`   | The resources limits for the container   | `{}`  |
| `resources.requests` | The requests resources for the container | `{}`  |


### Cronjobs configuration

| Name       | Description            | Value |
| ---------- | ---------------------- | ----- |
| `cronjobs` | Cronjobs configuration | `{}`  |

