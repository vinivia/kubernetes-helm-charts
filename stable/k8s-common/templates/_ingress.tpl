{{/* vim: set filetype=mustache: */}}

{{/*
Generate backend entry that is compatible with all Kubernetes API versions.

Usage:
{{ include "k8s-common.ingress.backend" (dict "serviceName" "backendName" "servicePort" "backendPort" "context" $) }}

Params:
  - serviceName - String. Name of an existing service backend
  - servicePort - String/Int. Port name (or number) of the service. It will be translated to different yaml depending if it is a string or an integer.
  - context - Dict - Required. The context for the template evaluation.
*/}}
{{- define "k8s-common.ingress.backend" -}}
{{- $apiVersion := (include "k8s-common.capabilities.ingress.apiVersion" .context) -}}
{{- if or (eq $apiVersion "extensions/v1beta1") (eq $apiVersion "networking.k8s.io/v1beta1") -}}
serviceName: {{ .serviceName }}
servicePort: {{ .servicePort }}
{{- else -}}
service:
  name: {{ .serviceName }}
  port:
    {{- if typeIs "string" .servicePort }}
    name: {{ .servicePort }}
    {{- else if typeIs "int" .servicePort }}
    number: {{ .servicePort }}
    {{- end }}
{{- end -}}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "k8s-common.ingress.annotations" -}}
kubernetes.io/ingress.class: "alb"

alb.ingress.kubernetes.io/actions.ssl-redirect: "{\"Type\":\"redirect\",\"RedirectConfig\":{\"Protocol\":\"HTTPS\",\"Port\":\"443\",\"StatusCode\":\"HTTP_301\"}}"
alb.ingress.kubernetes.io/backend-protocol: "HTTP"
# group name as cluster-name and optional '-public'
alb.ingress.kubernetes.io/group.name: {{ .Values.global.org }}-{{ .Values.global.environmentName }}{{ if .Values.ingress.public -}}-public{{- end }}
alb.ingress.kubernetes.io/healthcheck-path: "{{ .Values.service.healthCheckPath | default "/" }}"
alb.ingress.kubernetes.io/listen-ports: "[{\"HTTP\":80},{\"HTTPS\":443}]"
alb.ingress.kubernetes.io/scheme: {{ if .Values.ingress.public -}}internet-facing{{- else -}}internal{{- end }}
alb.ingress.kubernetes.io/security-groups: "generic-web{{ if .Values.ingress.public -}} ,generic-public-web{{- end -}}"
alb.ingress.kubernetes.io/ssl-policy: "ELBSecurityPolicy-TLS-1-2-2017-01"
alb.ingress.kubernetes.io/success-codes: "200"
alb.ingress.kubernetes.io/target-type: "ip"
{{- end -}}

{{- define "k8s-common.ingressExtra.annotations" -}}
kubernetes.io/ingress.class: "alb"

alb.ingress.kubernetes.io/actions.ssl-redirect: "{\"Type\":\"redirect\",\"RedirectConfig\":{\"Protocol\":\"HTTPS\",\"Port\":\"443\",\"StatusCode\":\"HTTP_301\"}}"
alb.ingress.kubernetes.io/backend-protocol: "HTTP"
alb.ingress.kubernetes.io/group.name: {{ .Release.Namespace }}-{{ include "k8s-common.names.name" . }}-extra
alb.ingress.kubernetes.io/healthcheck-path: "{{ .Values.service.healthCheckPath | default "/" }}"
alb.ingress.kubernetes.io/listen-ports: "[{\"HTTP\":80},{\"HTTPS\":443}]"
alb.ingress.kubernetes.io/scheme: {{ if .Values.ingressExtra.public -}}internet-facing{{- else -}}internal{{- end }}
alb.ingress.kubernetes.io/security-groups: "generic-web{{ if .Values.ingressExtra.public -}} ,generic-public-web{{- end -}}"
alb.ingress.kubernetes.io/ssl-policy: "{{ .Values.ingressExtra.tlsPolicy | default "ELBSecurityPolicy-TLS-1-2-2017-01"}}"
alb.ingress.kubernetes.io/success-codes: "200"
alb.ingress.kubernetes.io/target-type: "ip"
{{- end -}}

{{/*
Print "true" if the API pathType field is supported
Usage:
{{ include "k8s-common.ingress.supportsPathType" . }}
*/}}
{{- define "k8s-common.ingress.supportsPathType" -}}
{{- if (semverCompare "<1.18-0" (include "k8s-common.capabilities.kubeVersion" .)) -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

{{- define "k8s-common.ingress.serviceName" -}}
{{- if .Values.service.name -}}
{{ .Values.service.name }}
{{- else -}}
{{- if .Values.global.environmentName -}}
{{- if not (eq .Values.global.environmentName "prod") -}}
{{ .Values.global.environmentName }}-
{{- end -}}
{{- end -}}
{{- required "global.serviceName is missing" .Values.global.serviceName }}
{{- if .Values.service.suffix -}}
-{{ .Values.service.suffix }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "k8s-common.ingress.previewServiceName" -}}
preview-
{{- if .Values.global.environmentName -}}
{{- if not (eq .Values.global.environmentName "prod") -}}
{{ .Values.global.environmentName }}-
{{- end -}}
{{- end -}}
{{/*
This solution should be changed in the future.
*/}}
{{- if .Values.service.name -}}
{{ include "k8s-common.tplvalues.render" ( dict "value" .Values.service.name "context" $) }}
{{- else -}}
{{- required "global.serviceName is missing" .Values.global.serviceName }}
{{- end -}}
{{- end -}}

{{- define "k8s-common.ingress.host" -}}
{{- if .Values.global.environmentName -}}
{{ .Values.global.environmentName }}
{{- if .Values.ingress.subDomain -}}.{{- else -}}-{{- end -}}
{{- end -}}
{{ required "global.serviceName is missing" .Values.global.serviceName }}.
{{- required "global.org is missing" .Values.global.org }}
{{- if not .Values.global.production -}}-{{ .Values.global.environmentType }}{{- end -}}
.aws.
{{- required "global.domain is missing" .Values.global.domain }}
{{- end -}}

{{- define "k8s-common.ingress.extraHost" -}}
{{- if .Values.ingressExtra.host -}}
{{ .Values.ingressExtra.host }}
{{- else -}}
{{ .Values.global.environmentName }}
{{- if .Values.ingressExtra.subDomain -}}.{{- else -}}-{{- end -}}
{{- required "global.serviceName is missing" .Values.global.serviceName }}.
{{- required "global.org is missing" .Values.global.org }}
{{- if not .Values.global.production -}}-{{ .Values.global.environmentType }}{{- end -}}
.aws.
{{- required "global.domain is missing" .Values.global.domain }}
{{- end -}}
{{- end -}}
