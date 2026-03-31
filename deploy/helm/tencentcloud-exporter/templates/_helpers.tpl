{{/*
Expand the name of the chart.
*/}}
{{- define "tencentcloud-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tencentcloud-exporter.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart label value (chart name + version).
*/}}
{{- define "tencentcloud-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to all resources.
*/}}
{{- define "tencentcloud-exporter.labels" -}}
helm.sh/chart: {{ include "tencentcloud-exporter.chart" . }}
{{ include "tencentcloud-exporter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels used by Deployment and Service.
*/}}
{{- define "tencentcloud-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tencentcloud-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "tencentcloud-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tencentcloud-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the Secret that holds the Tencent Cloud credentials.
Returns the existingSecret name when set, otherwise the chart-managed secret name.
*/}}
{{- define "tencentcloud-exporter.secretName" -}}
{{- if .Values.config.credential.existingSecret }}
{{- .Values.config.credential.existingSecret }}
{{- else }}
{{- include "tencentcloud-exporter.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return true when credential env vars should be injected (either secret exists or was created).
*/}}
{{- define "tencentcloud-exporter.hasSecret" -}}
{{- if .Values.config.credential.existingSecret }}
{{- "true" }}
{{- else if and .Values.config.credential.accessKey .Values.config.credential.secretKey }}
{{- "true" }}
{{- end }}
{{- end }}
