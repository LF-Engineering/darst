{{- define "grimoire.config-init" }}
- name: {{ .Chart.Name }}-config-init
  image: "{{ .Values.image }}"
  imagePullPolicy: {{ .Values.imagePullPolicy }}
  command: ["/run/write_configs.sh", "-o", "/config"]
  env:
  - name: API_URL
    value: {{ .Values.api.url }}
  - name: PROJECT
    value: {{ .Values.projectSlug }}
  volumeMounts:
  - mountPath: /config
    name: config
{{- end }}
