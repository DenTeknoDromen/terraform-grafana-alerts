resource "grafana_folder" "terraform_folder" {
    title = var.folder_name
}

locals {
    input ="${yamldecode(file("input.yaml"))}"
}

resource "grafana_rule_group" "rule_group_terraform" {
  for_each         = local.input
  name             = each.value.group_name
  folder_uid       = grafana_folder.terraform_folder.uid
  interval_seconds = each.value.interval_seconds
  disable_provenance = true
  dynamic "rule" {
    for_each = each.value.rules
    content {
      name          = rule.value.rule_name
      condition     = "C"
      no_data_state = "NoData"
      exec_err_state = "Error"
      for           = "0m"

      annotations = {
        summary = rule.value.rule_summary
      }

      labels = {}

      notification_settings {
        contact_point = rule.value.contact_point
        group_by      = null
        mute_timings  = []
      }

      data {
        ref_id         = "A"
        datasource_uid = var.datasource_stackdriver_uid
        model = jsonencode({
            datasource      = { type = "stackdriver", uid = var.datasource_stackdriver_uid },
            instant         = false,
            intervalMs      = 1000,
            maxDataPoints   = 43200,
            queryType       = try(rule.value.query_type, "timeSeriesList"),
            range           = true,
            refId           = "A",
            timeSeriesList  = {
            alignmentPeriod    = try(rule.value.aggregations.alignment_period, "cloud-monitoring-auto"),
            crossSeriesReducer = try(rule.value.cross_series_reducer, "REDUCE_MEAN"),
            filters            = try(compact(regexall("\\b(?:AND|OR)\\b|[=]|[\\w.\\-/]*", rule.value.filters)), []),
            groupBys           = try(rule.value.aggregations.group_by_fields, []),
            perSeriesAligner   = try(rule.value.aggregations.per_series_aligner, null),
            preprocessor       = try(rule.value.pre_processor, "rate"),
            projectName        = try(rule.value.project_name, null),
            view               = "FULL"
            }
        })

        relative_time_range {
          from = 600
          to   = 0
        }
      }

      data {
        ref_id         = "B"
        datasource_uid = "-100"
        model          = jsonencode({
          expression    = "A",
          intervalMs    = 1000,
          maxDataPoints = 43200,
          reducer       = try(rule.value.reducer_type, "last"),
          refId         = "B",
          type          = "reduce"
        })

        relative_time_range {
          from = 0
          to   = 0
        }
      }

      data {
        ref_id         = "C"
        datasource_uid = "-100"
        model          = jsonencode({
          conditions = [{
            evaluator = {
              params = try([rule.value.threshold_value], null),
              type   = try(rule.value.threshold_type, "gt"),
            },
          }],
          expression    = "B",
          intervalMs    = 1000,
          maxDataPoints = 43200,
          refId         = "C",
          type          = try(rule.value.condition_type, "threshold")
        })

        relative_time_range {
          from = 0
          to   = 0
      }
    }
  }
}
}