{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "deployment.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "deployment.validateValues.org" .) -}}
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
{{- define "deployment.validateValues.org" -}}
{{- if not .Values.global.org -}}
deployment: global.org
    You must set a global.org
{{- end -}}
{{- end -}}
