
{{/*
Return TopologySpreadConstraints section 
Dict requiers  "customLabels" and "context" to proceed with "labelSelector"
{{- include "k8s-common.topologySpreadConstraintPreset"  (dict "type" .Values.topologySpreadConstraintPreset "customLabels" .Values.podLabels "context" $) }}
*/}}

{{- define "k8s-common.topologyspreadconstraints" -}}
- maxSkew: {{ .maxSkew }}
  topologyKey: {{ .topologyKey | default "topology.kubernetes.io/zone" }}
  whenUnsatisfiable: {{ .whenUnsatisfiable | default "ScheduleAnyway" }}
  labelSelector:
    matchLabels:
      {{- include "k8s-common.labels.matchLabels" (dict "customLabels" .customLabels  "context" .context) | nindent 6 }}
{{- end }}

{{/* maxSkew is set to 1 for the  hard presets. For the soft ones it equals 2 if minReplicas great than 10  */}}
{{- define "k8s-common.topologySpreadConstraintPreset" -}}
{{- $maxSkew := 1 }}
{{- if and .context.Values.autoscaling.enabled (ge (.context.Values.autoscaling.minReplicas | int) 10) }}
{{- $maxSkew = 2 }}
{{- end }}
  {{- if eq .type "soft" }}
    {{- include "k8s-common.topologyspreadconstraints" (dict "maxSkew" $maxSkew "customLabels" .customLabel "context" .context) -}}
  {{- else if eq .type "hard" }}
    {{- include "k8s-common.topologyspreadconstraints" (dict "maxSkew" 1 "whenUnsatisfiable" "DoNotSchedule" "customLabels" .customLabel "context" .context) -}}
  {{- end -}}
{{- end -}}