locals {
  team = lookup(jsondecode(data.http.service-registry-api.body), "team", null)
  org  = lookup(jsondecode(data.http.service-registry-api.body), "org", null)
}

data "http" "service-registry-api" {
  url = "https://serviceregistry-production-http.managed.services.opendoor.com/v1/service_owner/${var.service_key}"

  # The following attributes are exported: body (the raw body of the HTTP response)
}
