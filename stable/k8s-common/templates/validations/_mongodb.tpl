{{/* vim: set filetype=mustache: */}}
{{/*
Validate MongoDB(R) required passwords are not empty.

Usage:
{{ include "k8s-common.validations.values.mongodb.passwords" (dict "secret" "secretName" "subchart" false "context" $) }}
Params:
  - secret - String - Required. Name of the secret where MongoDB(R) values are stored, e.g: "mongodb-passwords-secret"
  - subchart - Boolean - Optional. Whether MongoDB(R) is used as subchart or not. Default: false
*/}}
{{- define "k8s-common.validations.values.mongodb.passwords" -}}
  {{- $existingSecret := include "k8s-common.mongodb.values.auth.existingSecret" . -}}
  {{- $enabled := include "k8s-common.mongodb.values.enabled" . -}}
  {{- $authPrefix := include "k8s-common.mongodb.values.key.auth" . -}}
  {{- $architecture := include "k8s-common.mongodb.values.architecture" . -}}
  {{- $valueKeyRootPassword := printf "%s.rootPassword" $authPrefix -}}
  {{- $valueKeyUsername := printf "%s.username" $authPrefix -}}
  {{- $valueKeyDatabase := printf "%s.database" $authPrefix -}}
  {{- $valueKeyPassword := printf "%s.password" $authPrefix -}}
  {{- $valueKeyReplicaSetKey := printf "%s.replicaSetKey" $authPrefix -}}
  {{- $valueKeyAuthEnabled := printf "%s.enabled" $authPrefix -}}

  {{- $authEnabled := include "k8s-common.utils.getValueFromKey" (dict "key" $valueKeyAuthEnabled "context" .context) -}}

  {{- if and (not $existingSecret) (eq $enabled "true") (eq $authEnabled "true") -}}
    {{- $requiredPasswords := list -}}

    {{- $requiredRootPassword := dict "valueKey" $valueKeyRootPassword "secret" .secret "field" "mongodb-root-password" -}}
    {{- $requiredPasswords = append $requiredPasswords $requiredRootPassword -}}

    {{- $valueUsername := include "k8s-common.utils.getValueFromKey" (dict "key" $valueKeyUsername "context" .context) }}
    {{- $valueDatabase := include "k8s-common.utils.getValueFromKey" (dict "key" $valueKeyDatabase "context" .context) }}
    {{- if and $valueUsername $valueDatabase -}}
        {{- $requiredPassword := dict "valueKey" $valueKeyPassword "secret" .secret "field" "mongodb-password" -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredPassword -}}
    {{- end -}}

    {{- if (eq $architecture "replicaset") -}}
        {{- $requiredReplicaSetKey := dict "valueKey" $valueKeyReplicaSetKey "secret" .secret "field" "mongodb-replica-set-key" -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredReplicaSetKey -}}
    {{- end -}}

    {{- include "k8s-common.validations.values.multiple.empty" (dict "required" $requiredPasswords "context" .context) -}}

  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for existingSecret.

Usage:
{{ include "k8s-common.mongodb.values.auth.existingSecret" (dict "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MongoDb is used as subchart or not. Default: false
*/}}
{{- define "k8s-common.mongodb.values.auth.existingSecret" -}}
  {{- if .subchart -}}
    {{- .context.Values.mongodb.auth.existingSecret | quote -}}
  {{- else -}}
    {{- .context.Values.auth.existingSecret | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for enabled mongodb.

Usage:
{{ include "k8s-common.mongodb.values.enabled" (dict "context" $) }}
*/}}
{{- define "k8s-common.mongodb.values.enabled" -}}
  {{- if .subchart -}}
    {{- printf "%v" .context.Values.mongodb.enabled -}}
  {{- else -}}
    {{- printf "%v" (not .context.Values.enabled) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for the key auth

Usage:
{{ include "k8s-common.mongodb.values.key.auth" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MongoDB(R) is used as subchart or not. Default: false
*/}}
{{- define "k8s-common.mongodb.values.key.auth" -}}
  {{- if .subchart -}}
    mongodb.auth
  {{- else -}}
    auth
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for architecture

Usage:
{{ include "k8s-common.mongodb.values.architecture" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MariaDB is used as subchart or not. Default: false
*/}}
{{- define "k8s-common.mongodb.values.architecture" -}}
  {{- if .subchart -}}
    {{- .context.Values.mongodb.architecture -}}
  {{- else -}}
    {{- .context.Values.architecture -}}
  {{- end -}}
{{- end -}}
