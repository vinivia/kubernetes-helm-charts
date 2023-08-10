{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper image name
{{ include "k8s-common.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "k8s-common.images.image" -}}
{{- $localImage := .Values.image | default dict }}
{{- $imageName := $localImage.name | default .Values.global.image.name -}}
{{- $tag := $localImage.tag | default .Values.global.image.tag | default .Values.global.environmentName | toString -}}

{{- printf "%s:%s" $imageName $tag -}}

{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
{{ include "k8s-common.images.pullSecrets" ( dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "global" .Values.global) }}
*/}}
{{- define "k8s-common.images.pullSecrets" -}}
  {{- $pullSecrets := list }}

  {{- if .global }}
    {{- range .global.imagePullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- range .images -}}
    {{- range .pullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
    {{- range $pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}
