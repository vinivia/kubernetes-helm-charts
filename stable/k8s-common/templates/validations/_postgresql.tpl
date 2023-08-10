{{/* vim: set filetype=mustache: */}}
{{/*
Validate PostgreSQL required passwords are not empty.

Usage:
{{ include "k8s-common.validations.values.postgresql.passwords" (dict "secret" "secretName" "subchart" false "context" $) }}
Params:
  - secret - String - Required. Name of the secret where postgresql values are stored, e.g: "postgresql-passwords-secret"
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "k8s-common.validations.values.postgresql.passwords" -}}
  {{- $existingSecret := include "k8s-common.postgresql.values.existingSecret" . -}}
  {{- $enabled := include "k8s-common.postgresql.values.enabled" . -}}
  {{- $valueKeyPostgresqlPassword := include "k8s-common.postgresql.values.key.postgressPassword" . -}}
  {{- $valueKeyPostgresqlReplicationEnabled := include "k8s-common.postgresql.values.key.replicationPassword" . -}}

  {{- if and (not $existingSecret) (eq $enabled "true") -}}
    {{- $requiredPasswords := list -}}

    {{- $requiredPostgresqlPassword := dict "valueKey" $valueKeyPostgresqlPassword "secret" .secret "field" "postgresql-password" -}}
    {{- $requiredPasswords = append $requiredPasswords $requiredPostgresqlPassword -}}

    {{- $enabledReplication := include "k8s-common.postgresql.values.enabled.replication" . -}}
    {{- if (eq $enabledReplication "true") -}}
        {{- $requiredPostgresqlReplicationPassword := dict "valueKey" $valueKeyPostgresqlReplicationEnabled "secret" .secret "field" "postgresql-replication-password" -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredPostgresqlReplicationPassword -}}
    {{- end -}}

    {{- include "k8s-common.validations.values.multiple.empty" (dict "required" $requiredPasswords "context" .context) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to decide whether evaluate global values.

Usage:
{{ include "k8s-common.postgresql.values.use.global" (dict "key" "key-of-global" "context" $) }}
Params:
  - key - String - Required. Field to be evaluated within global, e.g: "existingSecret"
*/}}
{{- define "k8s-common.postgresql.values.use.global" -}}
  {{- if .context.Values.global -}}
    {{- if .context.Values.global.postgresql -}}
      {{- index .context.Values.global.postgresql .key | quote -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for existingSecret.

Usage:
{{ include "k8s-common.postgresql.values.existingSecret" (dict "context" $) }}
*/}}
{{- define "k8s-common.postgresql.values.existingSecret" -}}
  {{- $globalValue := include "k8s-common.postgresql.values.use.global" (dict "key" "existingSecret" "context" .context) -}}

  {{- if .subchart -}}
    {{- default (.context.Values.postgresql.existingSecret | quote) $globalValue -}}
  {{- else -}}
    {{- default (.context.Values.existingSecret | quote) $globalValue -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for enabled postgresql.

Usage:
{{ include "k8s-common.postgresql.values.enabled" (dict "context" $) }}
*/}}
{{- define "k8s-common.postgresql.values.enabled" -}}
  {{- if .subchart -}}
    {{- printf "%v" .context.Values.postgresql.enabled -}}
  {{- else -}}
    {{- printf "%v" (not .context.Values.enabled) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for the key postgressPassword.

Usage:
{{ include "k8s-common.postgresql.values.key.postgressPassword" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "k8s-common.postgresql.values.key.postgressPassword" -}}
  {{- $globalValue := include "k8s-common.postgresql.values.use.global" (dict "key" "postgresqlUsername" "context" .context) -}}

  {{- if not $globalValue -}}
    {{- if .subchart -}}
      postgresql.postgresqlPassword
    {{- else -}}
      postgresqlPassword
    {{- end -}}
  {{- else -}}
    global.postgresql.postgresqlPassword
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for enabled.replication.

Usage:
{{ include "k8s-common.postgresql.values.enabled.replication" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "k8s-common.postgresql.values.enabled.replication" -}}
  {{- if .subchart -}}
    {{- printf "%v" .context.Values.postgresql.replication.enabled -}}
  {{- else -}}
    {{- printf "%v" .context.Values.replication.enabled -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for the key replication.password.

Usage:
{{ include "k8s-common.postgresql.values.key.replicationPassword" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "k8s-common.postgresql.values.key.replicationPassword" -}}
  {{- if .subchart -}}
    postgresql.replication.password
  {{- else -}}
    replication.password
  {{- end -}}
{{- end -}}
