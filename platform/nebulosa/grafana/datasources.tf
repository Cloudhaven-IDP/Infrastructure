resource "grafana_data_source" "loki" {
  type = "loki"
  name = "Loki"
  url  = local.loki_url

  json_data_encoded = jsonencode({
    maxLines = 1000
    derivedFields = [
      {
        name          = "Langfuse Trace"
        matcherRegex  = "\"trace_id\":\"([^\"]+)\""
        url           = "${local.langfuse_url}/trace/$${__value.raw}"
        datasourceUid = ""
      }
    ]
  })
}

resource "grafana_data_source" "victoriametrics" {
  type       = "prometheus"
  name       = "VictoriaMetrics"
  url        = local.victoriametrics_url
  is_default = true

  json_data_encoded = jsonencode({
    httpMethod    = "POST"
    timeInterval  = "30s"
    prometheusType = "Prometheus"
  })
}
