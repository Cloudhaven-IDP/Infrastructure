resource "grafana_data_source" "loki" {
  type = "loki"
  name = "Loki"
  url  = local.loki_url

  json_data_encoded = jsonencode({
    maxLines = 1000
    derivedFields = [
      {
        name          = "Langfuse Trace"
        matcherRegex  = "\"langfuse_trace_id\":\"([^\"]+)\""
        url           = "${local.langfuse_url}/trace/$${__value.raw}"
        datasourceUid = ""
      }
    ]
  })
}
