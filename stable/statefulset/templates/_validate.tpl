{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "statefulset.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "statefulset.validateValues.org" .) -}}
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
{{- define "statefulset.validateValues.org" -}}
{{- if not .Values.global.org -}}
deployment: global.org
    You must set a global.org
{{- end -}}
{{- end -}}
