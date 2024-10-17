output "team" {
  value       = local.team
  description = "The team from service registry that owns the service"
}

output "org" {
  value       = local.org
  description = "The org (EPOD) from service registry that owns the service"
}
