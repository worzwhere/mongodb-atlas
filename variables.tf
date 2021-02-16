variable "project_name" {
  description = "The name of the project you want to create"
  type        = string
}

variable "org_id" {
  description = "The ID of the Atlas organization you want to create the project within"
  type        = string
}

variable "teams" {
  description = "An object that contains all the groups that should be created in the project"
  type        = map(any)
  default     = {}
}

variable "white_lists" {
  description = "An object that contains all the network white-lists that should be created in the project"
  type        = map(any)
  default     = {}
}

variable "region" {
  description = "The AWS region-name that the cluster will be deployed on"
  type        = string
}

variable "cluster_name" {
  description = "The cluster name"
  type        = string
}

variable "instance_type" {
  description = "The Atlas instance-type name"
  type        = string
}

variable "mongodb_major_ver" {
  description = "The MongoDB cluster major version"
  type        = number
}

variable "cluster_type" {
  description = "The MongoDB Atlas cluster type - SHARDED/REPLICASET/GEOSHARDED"
  type        = string
}

variable "num_shards" {
  description = "number of shards"
  type        = number
}

variable "replication_factor" {
  description = "The Number of replica set members, possible values are 3/5/7"
  type        = number
  default     = null
}

variable "provider_backup" {
  description = "Indicating if the cluster uses Cloud Backup for backups"
  type        = bool
  default     = true
}

variable "pit_enabled" {
  description = "Indicating if the cluster uses Continuous Cloud Backup, if set to true - provider_backup must also be set to true"
  type        = bool
  default     = false
}

variable "disk_size_gb" {
  description = "Capacity,in gigabytes,of the host’s root volume"
  type        = number
  default     = null
}

variable "auto_scaling_disk_gb_enabled" {
  description = "Indicating if disk auto-scaling is enabled"
  type        = bool
  default     = true
}

variable "volume_type" {
  description = "STANDARD or PROVISIONED for IOPS higher than the default instance IOPS"
  type        = string
  default     = "STANDARD"
}

variable "provider_disk_iops" {
  description = "The maximum IOPS the system can perform"
  type        = number
  default     = null
}

variable "provider_encrypt_ebs_volume" {
  description = "Indicating if the AWS EBS encryption feature encrypts the server’s root volume"
  type        = bool
  default     = false
}

variable "vpc_peer" {
  description = "An object that contains all VPC peering requests from the cluster to AWS VPC's"
  type        = map(any)
  default     = {}
}

locals {
  cloud_provider = "AWS"
}

variable "backup_reference_hour_of_day" {
  description = "UTC Hour of day between 0 and 23, inclusive, representing which hour of the day that Atlas takes snapshots for backup policy items"
  default     = 3
}
variable "backup_reference_minute_of_hour" {
  description = "UTC Minutes after referenceHourOfDay that Atlas takes snapshots for backup policy items. Must be between 0 and 59, inclusive"
  default     = 45
}
variable "backup_restore_window_days" {
  description = "Number of days back in time you can restore to with point-in-time accuracy. Must be a positive, non-zero integer"
  default     = 4
}

variable "number_of_days_retention_hourly_backup" {
  description = "number of days the hourly backup will be keep"
  default     = 1
}
variable "number_of_days_retention_daily_backup" {
  description = "number of days the daily backup will be keep"
  default     = 2
}
variable "number_of_weeks_retention_weekly_backup" {
  description = "number of weeks the weekly backup will be keep"
  default     = 3
}
variable "number_of_months_retention_monthly_backup" {
  description = "number of months the monthly backup will be keep"
  default     = 3
}