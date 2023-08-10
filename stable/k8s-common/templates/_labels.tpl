{{/* vim: set filetype=mustache: */}}
{{/*
Kubernetes standard labels
*/}}
{{- define "k8s-common.labels.standard" -}}
app: {{ include "k8s-common.names.name" . }}
app.kubernetes.io/name: {{ include "k8s-common.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Release.Revision | quote }}
helm.sh/chart: {{ include "k8s-common.names.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "k8s-common.labels.matchLabels" -}}
app.kubernetes.io/name: {{ include "k8s-common.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
