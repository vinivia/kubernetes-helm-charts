{{- define "cronjobs.globalenv.value" -}}
{{- $allExtraEnv := default (dict) .Values.env.values -}}
{{- range $key, $value := $allExtraEnv }}
- name: {{ $key }}
  value: {{ include "k8s-common.tplvalues.render" (dict "value" $value "context" $) | quote }}
{{- end -}}
{{- end -}}

{{- define "cronjobs.job.value" -}}
{{- $allExtraEnv := default dict (default dict .env).values -}}
{{- range $key, $value := $allExtraEnv }}
- name: {{ $key }}
  value: {{ default "" $value | quote }}
{{- end -}}
{{- end -}}

{{- define "cronjobs.job.vaultSecret" -}}
{{- $globalVaultSecrets := default dict $.global.Values.env.vaultSecret -}}
{{- range $key, $value := $globalVaultSecrets }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.global.Release.Name }}-{{ $.global.Chart.Name }}-vault
      key: {{ $key }}
{{- end -}}
{{- $localVaultSecrets := default dict (default dict $.job.env).vaultSecret -}}
{{- range $key, $value := $localVaultSecrets }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $.global.Release.Name }}-{{ $.global.Chart.Name }}-{{ $.jobName }}-vault
      key: {{ $key }}
{{- end -}}
{{- end -}}
