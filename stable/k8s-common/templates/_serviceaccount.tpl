{{/* vim: set filetype=mustache: */}}
{{/*
Create the name of the service account to use
*/}}
{{- define "k8s-common.serviceAccount.name" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "k8s-common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
