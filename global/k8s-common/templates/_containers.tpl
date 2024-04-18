{{/* vim: set filetype=mustache: */}}
{{/*
Return generated container configuration.
{{- include "k8s-common.containers.container" . }}
*/}}
{{- define "k8s-common.containers.container" -}}
- name: "{{ include "k8s-common.names.fullname" . }}"
  image: "{{ include "k8s-common.images.image" . }}"
  imagePullPolicy: {{ (.Values.image).pullPolicy | default .Values.global.image.pullPolicy | quote }}
  {{- if .Values.command }}
  command: {{- toYaml .Values.command | nindent 2 }}
  {{- end }}
  {{- if .Values.args }}
  args: {{- toYaml .Values.args | nindent 2 }}
  {{- end }}
  {{- if or (.Values.env).values (.Values.env).refs (.Values.env).configmap (.Values.env).secret (.Values.env).vaultSecret }}
  env:
  {{- if .Values.env.values -}}
  {{- include "k8s-common.envvar.value" . | trim | nindent 2 -}}
  {{- end -}}
  {{- if or .Values.env.refs .Values.datadogIntegration -}}
  {{- include "k8s-common.envvar.ref" . | trim | nindent 2 -}}
  {{- end -}}
  {{- if .Values.env.configmap -}}
  {{- include "k8s-common.envvar.configmap" . | trim | nindent 2 -}}
  {{- end -}}
  {{- if .Values.env.secret -}}
  {{- include "k8s-common.envvar.secret" . | trim | nindent 2 -}}
  {{- end -}}
  {{- if .Values.env.vaultSecret -}}
  {{- include "k8s-common.envvar.vaultSecret" . | trim | nindent 2 -}}
  {{- end -}}
  {{- end -}}
  {{- if (.Values.livenessProbe).enabled }}
  livenessProbe:
    {{- if .Values.livenessProbe.tcpSocket }}
    tcpSocket:
      port: {{ .Values.livenessProbe.tcpSocket }}
    {{- else if .Values.service.ports.http }}
    httpGet:
      path: {{ .Values.livenessProbe.healthCheckPath | default .Values.service.healthCheckPath }}
      port: http
    {{- end }}
    initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds | default 0}}
    periodSeconds: {{ .Values.livenessProbe.periodSeconds | default 10 }}
    timeoutSeconds: {{ .Values.livenessProbe.timeoutSeconds | default 1 }}
    successThreshold: {{ .Values.livenessProbe.successThreshold | default 1 }}
    failureThreshold: {{ .Values.livenessProbe.failureThreshold | default 3 }}
  {{- end }}
  {{- if (.Values.readinessProbe).enabled }}
  readinessProbe:
    {{- if .Values.readinessProbe.tcpSocket }}
    tcpSocket:
      port: {{ .Values.readinessProbe.tcpSocket }}
    {{- else if .Values.service.ports.http }}
    httpGet:
      path: {{ .Values.readinessProbe.healthCheckPath | default .Values.service.healthCheckPath }}
      port: http
    {{- end }}
    initialDelaySeconds: {{ .Values.readinessProbe.initialDelaySeconds | default 0}}
    periodSeconds: {{ .Values.readinessProbe.periodSeconds | default 10 }}
    timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds | default 1 }}
    successThreshold: {{ .Values.readinessProbe.successThreshold | default 1 }}
    failureThreshold: {{ .Values.readinessProbe.failureThreshold | default 3 }}
  {{- end }}
  {{- if (.Values.startupProbe).enabled }}
  startupProbe:
    {{- if .Values.startupProbe.tcpSocket }}
    tcpSocket:
      port: {{ .Values.startupProbe.tcpSocket }}
    {{- else if .Values.service.ports.http }}
    httpGet:
      path: {{ .Values.startupProbe.healthCheckPath | default .Values.service.healthCheckPath }}
      port: http
    {{- end }}
    initialDelaySeconds: {{ .Values.startupProbe.initialDelaySeconds | default 0}}
    periodSeconds: {{ .Values.startupProbe.periodSeconds | default 10 }}
    timeoutSeconds: {{ .Values.startupProbe.timeoutSeconds | default 1 }}
    successThreshold: {{ .Values.startupProbe.successThreshold | default 1 }}
    failureThreshold: {{ .Values.startupProbe.failureThreshold | default 3 }}
  {{- end }}
  {{- if (.Values.service).ports }}
  ports:
  {{- range $key, $value := default (dict) .Values.service.ports }}
    - name: {{ $key }}
      containerPort: {{ $value }}
      protocol: TCP
  {{- end }}
  {{- end }}
  {{- if (.Values.lifecycle).enabled }}
  lifecycle:
  {{- if .Values.lifecycle.postStartCommand }}
    postStart:
      exec:
        command:
          - "/bin/sh"
          - "-c"
          - |
            {{ .Values.lifecycle.postStartCommand | nindent 12 }}
  {{- end }}
  {{- if .Values.lifecycle.preStopCommand }}
    preStop:
      exec:
        command:
          - "/bin/sh"
          - "-c"
          - |
            {{ .Values.lifecycle.preStopCommand | nindent 12 }}
  {{- end }}
  {{- end }}
  {{- if .Values.resources }}
  resources: {{- toYaml .Values.resources | trim | nindent 4 }}
  {{- else if ne .Values.resourcesPreset "none" }}
  resources: {{- include "k8s-common.resources.preset" (dict "type" .Values.resourcesPreset) | nindent 4 }}
  {{- end }}
  {{- if .Values.securityContext }}
  securityContext: {{- toYaml .Values.securityContext | trim | nindent 4 }}
  {{- end }}
  volumeMounts:
  {{- if .Values.volumes }}
  {{- include "k8s-common.volume.mounts" . | trim | nindent 4 }}
  {{- end }}
  {{- if (.Values.persistence).enabled }}
    - name: data
      mountPath: {{ required "peristence.path is required if persistence is enabled" .Values.persistence.path }}
  {{- end }}
{{- end -}}
