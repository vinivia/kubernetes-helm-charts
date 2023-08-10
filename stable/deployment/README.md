# deployment

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Typical microservice chart. Supports Ingress controller, horizontal-scalable containers

## Requirements

| Repository          | Name      | Version |
|---------------------|-----------|---------|
| file://../k8s-common | k8s-common | 1.0.0   |

## Upgrading
### To 4.1.0
- Update parameters
  - revert changes for `podSecurityContext` (removed defaults)
  - re-organize extra containers - 2 new parameters: `initContainers` and `sidecarContainers`
  - extra containers can have unique volumes
- Add support for `startupProbe`
### To 1.0.0
- Support vault secrets as files
  - `vaultVolumesSupport` - support for vault secrets as files
  - `volume.[].vaultPath` - path to the vault secret
  - `volume.[].items` - list of files to be retrieved
### To 4.0.3
- Support lifecycle hooks:
  - `preStopDelaySeconds` - delay for graceful pod shutdown
### To 4.0.1
- Resource naming changed to support 3.x
  - use `.global.serviceName` as default kubernetes resource name

### To 4.0.0
- The parameters below are renamed:
  - `replicas` -> `replicaCount`
  - `service.livenessProbe` -> `livenessProbe`
  - `service.readinessProbe` -> `readinessProbe`
- The parameters below where deprecated:
  - `service.port` deprecated in favor of `service.ports.http`
- Autoscaling configuration changed:
  - New parameter `autoscaling.metrics`
  - Deprecated `autoscaling.targetMemoryUtilizationPercentage`
  - Deprecated `autoscaling.targetCPUUtilizationPercentage`
  - Deprecated `autoscaling.requestsPerSecond`
- Support for the extra Ingress controller (legacy support)
- Support for PodDistributionBudget
- Support for the Ingress Path Type
- Support for tcpSocket probes
- Support for custom image
- Fix configMaps names
- Fix vaultSecret names
- Support additional `service.ports`
- Support for `podAffinityPreset`, `podAntiAffinityPreset`, `nodeAffinityPreset`
- Change `podSecurityContext` for nonRoot by default and 1001 user

## Parameters

### Global parameters

| Name                      | Description                                             | Value          |
| ------------------------- | ------------------------------------------------------- | -------------- |
| `global.serviceName`      | Name of the service. Affects public DNS.                | `example`      |
| `global.org`              | Company Organization Unit(product group).               | `example`      |
| `global.environmentType`  | Type of the environment, one of "dev", "stage", "prod". | `dev`          |
| `global.domain`           | Company Root-level domain, expects                      | `""`           |
| `global.production`       | Will the service run in production environment          | `false`        |
| `global.environmentName`  | Name of the environment, user-specified.                | `dev`          |
| `global.image.name`       | Name of the image,                                      | `""`           |
| `global.image.tag`        | Tag of the image                                        | `latest`       |
| `global.image.pullPolicy` | The default pull policy is IfNotPresent which causes    | `IfNotPresent` |


### Common parameters

| Name                                 | Description                                                                                    | Value   |
| ------------------------------------ | ---------------------------------------------------------------------------------------------- | ------- |
| `nameOverride`                       | By default, name uses '{{ .Chart.Name }}'.                                                     | `""`    |
| `fullnameOverride`                   | By default, fullname uses '{{ .Release.Name }}-{{ .Chart.Name }}'.                             | `""`    |
| `replicaCount`                       | Number of the parallel-running containers. The controller will eventually make the size of the | `1`     |
| `podAnnotations`                     | Additional annotations to apply to the pod.                                                    | `{}`    |
| `priorityClassName`                  | priorityClassName                                                                              | `""`    |
| `podSecurityContext`                 | Pod security context                                                                           | `{}`    |
| `securityContext`                    | Security context for the container                                                             | `{}`    |
| `vaultVolumesSupport`                | support for vault secrets as files. Defaults false.                                            | `false` |
| `volumes`                            | Container volumes configuration                                                                | `{}`    |
| `command`                            | You can set a custom entrypoint for your docker container                                      | `[]`    |
| `args`                               | You can set a custom arguments for your docker container                                       | `[]`    |
| `nodeSelector`                       | Node labels for pod assignment                                                                 | `{}`    |
| `tolerations`                        | Tolerations for pod assignment                                                                 | `[]`    |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`            | `""`    |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `soft`  |
| `preStopDelaySeconds`                | pre-stop delay for graceful pod shutdown                                                       | `0`     |
| `nodeAffinityPreset`                 | Node affinity preset                                                                           |         |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`      | `""`    |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                          | `""`    |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                      | `[]`    |
| `affinity`                           | Affinity for pod assignment                                                                    | `{}`    |
| `podDisruptionBudget`                | Pod disruption budget configuration                                                            |         |
| `podDisruptionBudget.create`         | Specifies whether a Pod disruption budget should be created                                    | `false` |
| `podDisruptionBudget.minAvailable`   | Min available pods or percent of pods                                                          | `1`     |
| `podDisruptionBudget.maxUnavailable` | Max non-available pods or percent of pods                                                      | `1`     |


### Extra Containers

| Name                | Description                          | Value |
| ------------------- | ------------------------------------ | ----- |
| `initContainers`    | Configuration for the init container | `[]`  |
| `sidecarContainers` | Configuration for the init container | `[]`  |


### Image for the deployment

| Name               | Description                                          | Value |
| ------------------ | ---------------------------------------------------- | ----- |
| `image.name`       | Name of the image,                                   | `""`  |
| `image.tag`        | Tag of the image                                     | `""`  |
| `image.pullPolicy` | The default pull policy is IfNotPresent which causes | `""`  |


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


### Configuration of the service

| Name                               | Description                                                     | Value       |
| ---------------------------------- | --------------------------------------------------------------- | ----------- |
| `service.enabled`                  | If service should be created to expose Pod.                     | `true`      |
| `service.name`                     | If you need to specify a service's full name override.          | `""`        |
| `service.type`                     | Type of the service. One of ClusterIP, NodePort, LoadBalancer.  | `ClusterIP` |
| `service.ports`                    | Configuration of the service ports                              | `{}`        |
| `service.healthCheckPath`          | default HTTP Health check for container liveness and readiness. | `/`         |
| `service.loadBalancerSourceRanges` | Address(es) that are allowed when service is LoadBalancer       | `[]`        |
| `service.annotations`              | Service annotations                                             | `{}`        |


### Container liveness configuration.

| Name                                | Description                                    | Value  |
| ----------------------------------- | ---------------------------------------------- | ------ |
| `livenessProbe.enabled`             | Enable livenessProbe                           | `true` |
| `livenessProbe.healthCheckPath`     | Request path for livenessProbe                 | `""`   |
| `livenessProbe.tcpSocket`           | Check availability on transport level via port | `0`    |
| `livenessProbe.initialDelaySeconds` | Initial delay seconds for livenessProbe        | `10`   |
| `livenessProbe.failureThreshold`    | Failure threshold for livenessProbe            | `3`    |
| `livenessProbe.periodSeconds`       | Period seconds for livenessProbe               | `10`   |
| `livenessProbe.successThreshold`    | Success threshold for livenessProbe            | `1`    |
| `livenessProbe.timeoutSeconds`      | Timeout seconds for livenessProbe              | `1`    |


### Container readiness configuration.

| Name                                 | Description                                    | Value  |
| ------------------------------------ | ---------------------------------------------- | ------ |
| `readinessProbe.enabled`             | Enable readinessProbe                          | `true` |
| `readinessProbe.healthCheckPath`     | Request path for readinessProbe                | `""`   |
| `readinessProbe.tcpSocket`           | Check availability on transport level via port | `0`    |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe           | `3`    |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe       | `10`   |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe              | `10`   |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe           | `1`    |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe             | `1`    |


### Container startUp configuration.

| Name                               | Description                                    | Value   |
| ---------------------------------- | ---------------------------------------------- | ------- |
| `startupProbe.enabled`             | Enable readinessProbe                          | `false` |
| `startupProbe.healthCheckPath`     | Request path for readinessProbe                | `""`    |
| `startupProbe.tcpSocket`           | Check availability on transport level via port | `0`     |
| `startupProbe.failureThreshold`    | Failure threshold for readinessProbe           | `3`     |
| `startupProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe       | `10`    |
| `startupProbe.periodSeconds`       | Period seconds for readinessProbe              | `10`    |
| `startupProbe.successThreshold`    | Success threshold for readinessProbe           | `1`     |
| `startupProbe.timeoutSeconds`      | Timeout seconds for readinessProbe             | `1`     |


### Configuration for the main load-balancer

| Name                  | Description                                                                      | Value    |
| --------------------- | -------------------------------------------------------------------------------- | -------- |
| `ingress.enabled`     | If service will be accessible outside of Kubernetes environment                  | `false`  |
| `ingress.pathType`    | Type of the path (available options "ImplementationSpecific", "Exact", "Prefix") | `Prefix` |
| `ingress.public`      | If container will be accessible outside VPN.                                     | `false`  |
| `ingress.subDomain`   | If DNS has environment as sub-domain.                                            | `false`  |
| `ingress.path`        | Prefix for the path routing                                                      | `/`      |
| `ingress.annotations` | Ingress annotations                                                              | `{}`     |
| `ingress.extraHosts`  | Extra hosts for ingress                                                          | `[]`     |


### Configuration for the extra load-balancer

| Name                       | Description                                                                      | Value    |
| -------------------------- | -------------------------------------------------------------------------------- | -------- |
| `ingressExtra.enabled`     | If service will be accessible outside of Kubernetes environment                  | `false`  |
| `ingressExtra.pathType`    | Type of the path (available options "ImplementationSpecific", "Exact", "Prefix") | `Prefix` |
| `ingressExtra.public`      | If container will be accessible outside VPN.                                     | `false`  |
| `ingressExtra.subDomain`   | If DNS has environment as sub-domain.                                            | `false`  |
| `ingressExtra.host`        | DNS for the application external access                                          | `""`     |
| `ingressExtra.path`        | Prefix for the path routing                                                      | `/`      |
| `ingressExtra.annotations` | Ingress annotations                                                              | `{}`     |
| `ingressExtra.extraHosts`  | Extra hosts for ingress                                                          | `[]`     |


### Prometheus Exporter / Metrics

| Name                                   | Description                                  | Value      |
| -------------------------------------- | -------------------------------------------- | ---------- |
| `metrics.enabled`                      | Enable prometheus to access metrics endpoint | `false`    |
| `metrics.path`                         | Path to the prometheus metrics endpoint      | `/metrics` |
| `metrics.serviceMonitor.enabled`       | Create ServiceMonitor object                 | `false`    |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped  | `10s`      |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended      | `3s`       |
| `metrics.serviceMonitor.selector`      | Additional labels for ServiceMonitor object  | `{}`       |
| `metrics.rules.enabled`                | Create PrometheusRules object                | `false`    |
| `metrics.rules.spec`                   | Configuration for the application alerting   | `[]`       |


### Container resource requests and limits

| Name                 | Description                              | Value |
| -------------------- | ---------------------------------------- | ----- |
| `resources.limits`   | The resources limits for the container   | `{}`  |
| `resources.requests` | The requests resources for the container | `{}`  |


### Lifecycle configuration

| Name                         | Description                                      | Value   |
| ---------------------------- | ------------------------------------------------ | ------- |
| `lifecycle.enabled`          | Enable lifecycle hooks                           | `false` |
| `lifecycle.postStartCommand` | Command to be executed after the container start | `""`    |
| `lifecycle.preStopCommand`   | Command to be executed before container shutdown | `""`    |


### Create HorizontalPodAutoscaler object for deployment type

| Name                      | Description                      | Value   |
| ------------------------- | -------------------------------- | ------- |
| `autoscaling.enabled`     | If autoscaling is enabled        | `false` |
| `autoscaling.minReplicas` | Min number of pod replicas       | `1`     |
| `autoscaling.maxReplicas` | Max number of pod replicas       | `1`     |
| `autoscaling.metrics`     | Configuration of scaling metrics | `[]`    |


### Persistence Parameters

| Name                       | Description                                       | Value   |
| -------------------------- | ------------------------------------------------- | ------- |
| `persistence.enabled`      | Enable persistence using Persistent Volume Claims | `false` |
| `persistence.path`         | Path to mount persistent volume                   | `""`    |
| `persistence.storageClass` | Persistent Volume storage class                   | `""`    |
| `persistence.annotations`  | Additional custom annotations for the PVC         | `{}`    |
| `persistence.accessModes`  | Persistent Volume access modes                    | `[]`    |
| `persistence.size`         | Persistent Volume size                            | `8Gi`   |


### Configuration for Argo Rollouts

| Name                             | Description                                                              | Value    |
| -------------------------------- | ------------------------------------------------------------------------ | -------- |
| `rollouts.enabled`               | If Argo Rollouts will be created instead of Deployment                   | `false`  |
| `rollouts.strategy`              | Argo Rollouts strategy. Allowed values: `canary` or `blueGreen`          | `canary` |
| `rollouts.steps`                 | Steps define sequence of steps to take during an update of the canary.   | `[]`     |
| `rollouts.autoPromotionEnabled`  | Indicates if the rollout should automatically promote the new ReplicaSet | `true`   |
| `rollouts.autoPromotionSeconds`  | Automatically promotes the current ReplicaSet to active after the        | `0`      |
| `rollouts.scaleDownDelaySeconds` | Adds a delay before scaling down the previous ReplicaSet. If omitted,    | `30`     |

