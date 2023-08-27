{{/* vim: set filetype=mustache: */}}
{{/*
Return generated volume mounts.
{{- include "k8s-common.volume.mounts" . }}
*/}}
{{- define "k8s-common.volume.mounts" -}}
{{- $allVolumes := default (dict) .Values.volumes -}}
{{- range $key, $value := $allVolumes }}
{{- if $value.mountPath }}
- name: {{ $key }}
  mountPath: {{ $value.mountPath }}
  {{ if $value.subPath -}}
  subPath: {{ $value.subPath }}
  {{ end -}}
  {{ if or $value.secretName $value.vaultPath -}}
  readOnly: true
  {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return generated volume definitions.
{{- include "k8s-common.volume.definitions" . }}
*/}}
{{- define "k8s-common.volume.definitions" -}}
{{- $allVolumes := default (dict) .Values.volumes -}}
{{- range $key, $value := $allVolumes }}
- name: {{ $key }}
  {{ if $value.emptyDir -}}
  emptyDir: {}
  {{- else if $value.configMap -}}
  configMap:
    name: {{ include "k8s-common.names.fullname" $ }}-{{ $key }}
  {{- else if $value.secretName -}}
  secret:
    secretName: {{ $value.secretName }}
  {{- else if $value.vaultPath -}}
  secret:
    secretName: {{ include "k8s-common.names.fullname" $ }}-vault-{{ $key }}
  {{- end -}}
{{- end -}}
{{- range .Values.sidecarContainers }}
{{- $allVolumes := default (dict) .volumes -}}
{{- range $key, $value := $allVolumes }}
- name: {{ $key }}
  {{ if $value.emptyDir -}}
  emptyDir: {}
  {{- else if $value.configMap -}}
  configMap:
    name: {{ include "k8s-common.names.fullname" $ }}-{{ $key }}
  {{- else if $value.secretName -}}
  secret:
    secretName: {{ $value.secretName }}
  {{- else if $value.vaultPath -}}
  secret:
    secretName: {{ include "k8s-common.names.fullname" $ }}-vault-{{ $key }}
  {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return generated volume definitions.
{{- include "k8s-common.volume.claims" . }}
*/}}
{{- define "k8s-common.volume.claims" -}}
{{- $allVolumes := default (dict) .Values.volumes -}}
{{- range $key, $value := $allVolumes }}
{{- if $value.storage -}}
- metadata:
    name: {{ $key }}
  spec:
    accessModes: [ "ReadWriteOnce" ]
    resources:
      requests:
        storage: {{ $value.storage }}
{{- end -}}
{{- end -}}
{{- end -}}
