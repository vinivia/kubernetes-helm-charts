{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "daemonset.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "daemonset.validateValues.product" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Deployment:
- must set a org
*/}}
{{- define "daemonset.validateValues.product" -}}
{{- if not .Values.global.product -}}
deployment: global.product
    You must set a global.product
{{- end -}}
{{- end -}}
