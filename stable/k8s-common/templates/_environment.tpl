{{/* vim: set filetype=mustache: */}}
{{/*
Generate environment variables.
{{- include "k8s-common.envvar.value" . -}}
*/}}
{{- define "k8s-common.envvar.value" -}}
{{- $allExtraEnv := default (dict) .Values.env.values -}}
{{- range $key, $value := $allExtraEnv }}
- name: {{ $key }}
  value: {{ include "k8s-common.tplvalues.render" (dict "value" $value "context" $) | quote }}
{{- end -}}
{{- end -}}

{{/*
Generate environment variables as refs.
{{- include "k8s-common.envvar.ref" . -}}
*/}}
{{- define "k8s-common.envvar.ref" -}}
{{- $allExtraEnv := default (dict) .Values.env.refs -}}
{{- range $key, $value := $allExtraEnv }}
- name: {{ $key }}
  valueFrom:
    fieldRef:
      fieldPath: {{ $value }}
{{- end -}}
{{- end -}}

{{/*
Generate ConfigMap based variables.
{{- include "k8s-common.envvar.configmap" . -}}
*/}}
{{- define "k8s-common.envvar.configmap" -}}
{{- $allEnvConfigMaps := default (dict) .Values.env.configmap -}}
{{- range $key, $value := $allEnvConfigMaps }}
- name: {{ $key }}
  valueFrom:
    configMapKeyRef:
      name: {{ $value.name }}
      key: {{ $value.key | quote }}
{{- end -}}
{{- end -}}

{{/*
Generate Secret based variables.
{{- include "k8s-common.envvar.secret" . -}}
*/}}
{{- define "k8s-common.envvar.secret" -}}
{{- $allEnvSecrets := default (dict) .Values.env.secret -}}
{{- range $key, $value := $allEnvSecrets }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $value.name }}
      key: {{ $value.secret | quote }}
{{- end -}}
{{- end -}}

{{/*
Generate Secrets based on Vault secrets.
{{- include "k8s-common.envvar.vaultSecret" . -}}
*/}}
{{- define "k8s-common.envvar.vaultSecret" -}}
{{- $allVaultSecrets := default (dict) .Values.env.vaultSecret -}}
{{- range $key, $value := $allVaultSecrets }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ include "k8s-common.names.fullname" $ }}-vault
      key: {{ $key }}
{{- end -}}
{{- end -}}
