{{/*
Common name
*/}}
{{- define "muffin-currency.common-name" -}}
{{ .Release.Name }}-currency
{{- end}}


{{/*
Muffin liveness probe
*/}}
{{- define "muffin-currency.muffin-livenessProbe" -}}
httpGet:
    path: {{ .Values.muffinCurrency.pod.livenessProbe.httpGet.path }}
    port: {{ .Values.muffinCurrency.pod.livenessProbe.httpGet.port }}
initialDelaySeconds: {{ .Values.muffinCurrency.pod.livenessProbe.initialDelaySeconds }}
periodSeconds: {{ .Values.muffinCurrency.pod.livenessProbe.periodSeconds }}
{{- end }}

{{/*
Muffin liveness probe
*/}}
{{- define "muffin-currency.muffin-readinessProbe" -}}
httpGet:
    path: {{ .Values.muffinCurrency.pod.readinessProbe.httpGet.path }}
    port: {{ .Values.muffinCurrency.pod.readinessProbe.httpGet.port }}
initialDelaySeconds: {{ .Values.muffinCurrency.pod.readinessProbe.initialDelaySeconds }}
periodSeconds: {{ .Values.muffinCurrency.pod.readinessProbe.periodSeconds }}
{{- end }}

{{/*
Deploymant match labels
*/}}
{{- define "muffin-currency.muffin-match-labels" -}}
app: muffin-currency
{{- end }}

{{/*
Deployment labels
*/}}
{{- define "muffin-currency.deployment-labels" -}}
{{ include "muffin-currency.muffin-match-labels" . }}
{{- end }}
