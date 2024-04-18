# vaultsecrets

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Generator of the secrets from remote Vault server

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../k8s-common | k8s-common | 2.0.0   |

## Parameters

### Global parameters

| Name                      | Description                                             | Value          |
| ------------------------- | ------------------------------------------------------- | -------------- |
| `global.product`          | The product of the service                              | `""`           |
| `global.serviceName`      | Name of the service. Affects public DNS.                | `example`      |
| `global.environment`      | Type of the environment, one of "dev", "stage", "prod". | `dev`          |
| `global.domain`           | Company Root-level domain, expects                      | `""`           |
| `global.image.name`       | Name of the image,                                      | `""`           |
| `global.image.tag`        | Tag of the image                                        | `latest`       |
| `global.image.pullPolicy` | The default pull policy is IfNotPresent which causes    | `IfNotPresent` |

### Kubernetes secrets

| Name          | Description                                                  | Value |
| ------------- | ------------------------------------------------------------ | ----- |
| `kubeSecrets` | Secrets that get added to the container from Hashicorp Vault | `{}`  |

