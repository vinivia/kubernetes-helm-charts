{{/*
Return TopologySpreadConstraints section
Dict requiers  "customLabels" and "context" to proceed with "labelSelector"
*/}}

{{/*
Generate topology contstraints based on preset.
* hard:
  maxSkew is 1
  DoNotSchedule if condition is unsatisfiable for the kubernetes zone
* soft:
  maxSkew is 2 for autoscalling with more than 10 replicas, else 1
  scheduleAnyway if constraints are unsatisfiable.
{{- include "k8s-common.topologySpreadConstraintPreset"  (dict "type" .Values.topologySpreadConstraintPreset "context" $) }}
*/}}
{{- define "k8s-common.topologySpreadConstraintPreset" -}}
{{- $maxSkew := 1 }}
{{- if and .context.Values.autoscaling.enabled (ge (.context.Values.autoscaling.minReplicas | int) 10) }}
{{- $maxSkew = 2 }}
{{- end }}
  {{- if eq .type "soft" }}
    {{- include "k8s-common.topologyspreadconstraints" (dict "maxSkew" $maxSkew "context" .context) -}}
  {{- else if eq .type "hard" }}
    {{- include "k8s-common.topologyspreadconstraints" (dict "maxSkew" 1 "whenUnsatisfiable" "DoNotSchedule" "context" .context) -}}
  {{- end -}}
{{- end -}}

{{/*
Generate topology spread constraints
{{- include "k8s-common.topologyspreadconstraints"  (dict "maxSkew" 1 "whenUnsatisfiable" "DoNotSchedule" "topologyKey" "topology.kubernetes.io/zone" "context" $) }}
*/}}
{{- define "k8s-common.topologyspreadconstraints" -}}
- maxSkew: {{ .maxSkew | default 1 }}
  topologyKey: {{ .topologyKey | default "topology.kubernetes.io/zone" }}
  whenUnsatisfiable: {{ .whenUnsatisfiable | default "ScheduleAnyway" }}
  labelSelector:
    matchLabels: {{- include "k8s-common.labels.matchLabels" (dict "customLabels" .context.Values.podLabels "context" .context) | nindent 6 }}
{{- end }}
