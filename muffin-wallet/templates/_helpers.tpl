{{/*
Common name
*/}}
{{- define "muffin-wallet.common-name" -}}
{{ .Release.Name }}-wallet
{{- end}}


{{/*
Muffin liveness probe
*/}}
{{- define "muffin-wallet.muffin-livenessProbe" -}}
httpGet:
    path: {{ .Values.muffinWallet.pod.livenessProbe.httpGet.path }}
    port: {{ .Values.muffinWallet.pod.livenessProbe.httpGet.port }}
initialDelaySeconds: {{ .Values.muffinWallet.pod.livenessProbe.initialDelaySeconds }}
periodSeconds: {{ .Values.muffinWallet.pod.livenessProbe.periodSeconds }}
{{- end }}

{{/*
Muffin liveness probe
*/}}
{{- define "muffin-wallet.muffin-readinessProbe" -}}
httpGet:
    path: {{ .Values.muffinWallet.pod.readinessProbe.httpGet.path }}
    port: {{ .Values.muffinWallet.pod.readinessProbe.httpGet.port }}
initialDelaySeconds: {{ .Values.muffinWallet.pod.readinessProbe.initialDelaySeconds }}
periodSeconds: {{ .Values.muffinWallet.pod.readinessProbe.periodSeconds }}
{{- end }}

{{/*
Deploymant match labels
*/}}
{{- define "muffin-wallet.muffin-match-labels" -}}
app: {{ include "muffin-wallet.common-name" . }}
{{- end }}

{{/*
Deployment labels
*/}}
{{- define "muffin-wallet.deployment-labels" -}}
{{ include "muffin-wallet.muffin-match-labels" . }}
{{- end }}

{{/*
Deployment ingress paths
*/}}
{{- define "muffin-wallet.ingress-paths" -}}
- path: /
  pathType: Prefix
  backend:
    service:
        name: {{ include "muffin-wallet.common-name" . }}
        port:
            number: 80
{{- end }}

{{/*
Volumes
*/}}
{{- define "muffin-wallet.volumes" -}}
- name: application-config-volume
  configMap:
    name: {{ include "muffin-wallet.common-name" . }}
{{- end }}

{{/*
Volume mounts
*/}}
{{- define "muffin-wallet.volume-mounts" -}}
- name: application-config-volume
  mountPath: /app/config
{{- end }}

{{/*
Config map data
*/}}
{{- define "muffin-wallet.configMap-data" -}}
application.yaml: |
    ---
    server:
        port: 8081

    spring:
        application:
            name: muffin-wallet
        datasource:
            url: jdbc:postgresql://{{ .Values.muffinWallet.database.host }}:{{ .Values.muffinWallet.database.port }}/{{ .Values.muffinWallet.database.name }}
            username: {{ .Values.muffinWallet.database.username }}
            driver-class-name: org.postgresql.Driver

    currency:
        service:
            url: http://{{ .Values.muffinWallet.currency.service.name }}:{{ .Values.muffinWallet.currency.service.port }}/rate
    management:
        endpoints:
            web:
                exposure:
                    include: health, info, prometheus
        endpoint:
            health:
                probes:
                    enabled: true
                show-details: always
        metrics:
            distribution:
                percentiles-histogram:
                    http.server.requests: true
                percentiles:
                    http.server.requests: [0.5, 0.95, 0.99]
        tracing:
            enabled: {{ .Values.muffinWallet.zipkin.enabled }}
            sampling:
                probability: 1.0
            service-name: muffin-wallet
        zipkin:
            base-url: {{ .Values.muffinWallet.zipkin.baseUrl | quote }}
            sender:
                type: web
{{- end }}
