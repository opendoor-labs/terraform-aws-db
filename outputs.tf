output "url" {
  value       = "postgres://${var.username}:${random_string.password.result}@${aws_db_instance.db.endpoint}/${local.database_name}"
  sensitive   = true
  description = "The fully qualified URL of the database instance."
}

output "username" {
  value       = var.username
  sensitive   = true
  description = "The username for this database"
}

output "password" {
  value       = random_string.password.result
  sensitive   = true
  description = "The password for this database"
}

output "endpoint" {
  value       = aws_db_instance.db.endpoint
  sensitive   = true
  description = "The endpoint for this database in address:port format"
}

output "address" {
  value       = aws_db_instance.db.address
  sensitive   = true
  description = "The address for this database"
}

output "database_name" {
  value       = local.database_name
  description = "The database name"
}

output "id" {
  value       = aws_db_instance.db.id
  description = "The database RDS instance ID"
}
