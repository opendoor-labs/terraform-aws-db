variable "name" {
  type        = string
  default     = ""
  description = "Deprecated. Name of your service, used to generate db identifier and dbname"
}

variable "database_name" {
  type        = string
  default     = ""
  description = "Name of your database."
}

variable "identifier_suffix" {
  type        = string
  default     = ""
  description = "A suffix to tack on to the db identifier. Typically used for replicas."
}

variable "replicate_source_db" {
  type        = string
  default     = null
  description = "If provided, replicate the database indicated."
}

variable "app" {
  type        = string
  default     = ""
  description = "Name of your app."
}

variable "env" {
  type        = string
  default     = "staging"
  description = "Either 'staging' or 'production'."
}

variable "username" {
  type        = string
  default     = "opendoor"
  description = "Username of database role."
}

variable "password_length" {
  type        = string
  default     = "32"
  description = "Length of the generated password."
}

variable "storage" {
  type        = string
  default     = "20"
  description = "Allocated size of the database in gigabytes."
}

variable "max_storage" {
  type        = number
  default     = 0
  description = "Maximum allocated size of the database in gigabytes, enables autoscaling."
}

variable "security_groups" {
  type        = list(string)
  default     = ["sg-70078f39"]
  description = "List of VPC security groups this database belongs to."
}

variable "staging_security_groups" {
  type        = list(string)
  default     = ["sg-0286bbf77920906ee"]
  description = "List of VPC security groups the staging instance(s) of this database will belong to."
}

variable "prod_security_groups" {
  type        = list(string)
  default     = ["sg-0508423c1f45a33dd"]
  description = "List of VPC security groups the prod instance(s) of this database will belong to."
}

variable "additional_security_groups" {
  type        = list(string)
  default     = []
  description = "List of additional VPC security groups"
}

variable "instance_class" {
  type        = string
  default     = ""
  description = "The instance type of the RDS instance."
}

variable "backup_retention_period" {
  type        = string
  default     = "7"
  description = "Number of days to retain backups for."
}

variable "iops" {
  type        = number
  default     = 0
  description = "The amount of provisioned IOPS. Setting this requires declaring storage_type of 'io1'."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "If the DB instance has deletion protection enabled, the database can't be deleted"
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "Defaults to 'gp2' (general purpose SSD), alternatives: 'standard' (magnetic) or 'io1' (provisioned IOPS SSD)."
}

variable "storage_encrypted" {
  type        = string
  default     = ""
  description = "Whether the storage should be encrypted at rest."
}

variable "engine_version" {
  type = string
  # We only specify the major version because we have auto minor version upgrade enabled in RDS.
  default     = "11"
  description = "Version of Postgres to use."
}

variable "parameter_group" {
  type        = string
  default     = ""
  description = "Name of the parameter group to use. If unset, will default to default.postgres[major], determined automatically from engine_version. Only set this if you want to use a non-default parameter group"
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = true
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Indicates that minor version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible."
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether any database modifications are applied immediately, or during the next maintenance window."
}

variable "performance_insights_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Specifies whether Performance Insights is enabled or not."
}

variable "performance_insights_retention_period" {
  type        = number
  default     = 7
  description = "(Optional) Amount of time in days to retain Performance Insights data."
}

variable "performance_insights_kms_key_id" {
  type        = string
  default     = ""
  description = "(Optional) The ARN for the KMS key to encrypt Performance Insights data. When specifying performance_insights_kms_key_id, performance_insights_enabled needs to be set to true."
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Should the database be publicly accessible? (DO NOT USE UNLESS ABSOLUTELY NECESSARY)"
}

variable "maintenance_window" {
  type        = string
  default     = "mon:07:00-mon:08:00"
  description = "Maintenance window in (UTC) ddd:hh24:mi-ddd:hh24:mi format and must not overlap with the backup window"
}

variable "backup_window" {
  type        = string
  default     = "05:30-06:00"
  description = "Backup window in (UTC) hh24:mi-hh24:mi format and must not overlap with the maintance window"
}

variable "timeout_create" {
  type        = string
  default     = "40m"
  description = "When will RDS creation timeout? 40m is the default"
}

variable "timeout_delete" {
  type        = string
  default     = "60m"
  description = "When will RDS delete timeout? 60m is the default"
}

variable "timeout_update" {
  type        = string
  default     = "80m"
  description = "When will RDS update timeout? 80 is the default"
}

variable "sox_related" {
  type        = bool
  default     = false
  description = "Whether the RDS is in SOX scope"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "AWS tags in addition to auto-generated tags"
}
