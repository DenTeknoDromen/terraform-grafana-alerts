terraform {
    required_providers {
        grafana = {
            source = "grafana/grafana"
            version = ">= 2.9.0"
        }
    }
}

provider "grafana" {
    url = var.grafana_url
    auth = var.auth_token
}