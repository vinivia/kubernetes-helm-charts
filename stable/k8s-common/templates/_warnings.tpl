{{/* vim: set filetype=mustache: */}}
{{/*
Warning about using rolling tag.
Usage:
{{ include "k8s-common.warnings.rollingTag" .Values.path.to.the.imageRoot }}
*/}}
{{- define "k8s-common.warnings.rollingTag" -}}

{{- if and (contains "global/" .repository) (not (.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .repository }}:{{ .tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
{{- end }}

{{- end -}}
