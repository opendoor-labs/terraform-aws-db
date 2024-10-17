locals {
  is_production = var.env == "production"
  is_replica    = var.replicate_source_db != null

  app           = var.app != "" ? var.app : var.name
  database_name = "${var.database_name != "" ? var.database_name : replace(local.app, "-", "_")}_${var.env}"

  default_instance_class = local.is_production ? "db.m5.large" : "db.t4g.medium"
  instance_class         = var.instance_class != "" ? var.instance_class : local.default_instance_class

  # Note: This doesn't work for PostgreSQL 9, since each "minor" version is actually a major version
  # Luckily we don't have any services using this module with databases on PG 9 or below.
  major_engine_version = split(".", var.engine_version)[0]
  // managed-postgres-<engine version> is defined in commmon/terraform/code/parameter_groups.tf
  default_parameter_group = "managed-postgres-${local.major_engine_version}"
  parameter_group         = var.parameter_group != "" ? var.parameter_group : local.default_parameter_group

  identifier = "${local.app}-${var.env}${var.identifier_suffix}"
}

module "ownership" {
  source = "./ownership"

  service_key = local.app
}

resource "random_string" "password" {
  length  = var.password_length
  special = false
}

# https://www.terraform.io/docs/providers/aws/r/db_instance.html
resource "aws_db_instance" "db" {
  identifier            = local.identifier
  instance_class        = local.instance_class
  allocated_storage     = var.storage
  max_allocated_storage = var.max_storage
  engine                = "postgres"
  engine_version        = var.engine_version
  backup_window         = var.backup_window
  maintenance_window    = var.maintenance_window
  parameter_group_name  = local.parameter_group
  username              = var.username
  ca_cert_identifier    = "rds-ca-rsa2048-g1"
  name                  = local.database_name
  publicly_accessible   = var.publicly_accessible
  # Note: Staging and Production should have distinct security groups, but currently share one.
  vpc_security_group_ids = concat(var.security_groups, local.is_production ? var.prod_security_groups : var.staging_security_groups, var.additional_security_groups)

  # replica databases always have the same password as the master, so we shouldn't try to
  # generate and configure a separate password for the replica
  password = var.replicate_source_db == null ? random_string.password.result : null

  # replica databases should not have a subnet group name explicitly configured
  db_subnet_group_name = var.replicate_source_db == null ? "rds-backend" : null
  # read-only replicas are not allowed to have backups
  backup_retention_period             = var.replicate_source_db == null ? var.backup_retention_period : null
  iam_database_authentication_enabled = false

  multi_az                              = local.is_production && ! local.is_replica
  storage_type                          = var.storage_type
  storage_encrypted                     = var.storage_encrypted != "" ? var.storage_encrypted : local.is_production
  skip_final_snapshot                   = var.replicate_source_db == null ? ! local.is_production : true
  final_snapshot_identifier             = var.replicate_source_db == null && local.is_production ? "${local.identifier}-final" : null
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  iops                                  = var.iops
  deletion_protection                   = var.deletion_protection
  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]

  # by default this is null, so won't count as really provided
  replicate_source_db = var.replicate_source_db

  lifecycle {
    prevent_destroy = true
  }

  timeouts {
    create = var.timeout_create
    delete = var.timeout_delete
    update = var.timeout_update
  }

  tags = merge(var.custom_tags, {
    app = local.app
    # If the ownership module returns null for these values, the tags won't be included at all.
    team        = module.ownership.team
    org         = module.ownership.org
    env         = var.env
    sox_related = var.sox_related
  })
}
