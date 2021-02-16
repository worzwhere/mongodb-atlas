# Canada's Variables

variable "provider_region" {
  type        = string
  description = "Name of the provider region"
}

variable "project_name" {
  type        = string
  description = "Name to use for project"
}

variable "org_id" {
  type        = string
  description = "org id number to use"
}

# variable "users" {
#   type        = string
#   description = "user to use for mongodb admin"
# }

# variable "role" {
#   type        = string
#   description = "role to use for mongodb admin"
# }

variable "white_lists" {
  type        = string
  description = "IP white lists for connect to the cluster"
}

variable "cluster_region" {
  type        = string
  description = "cluster region"
}

variable "cluster_name" {
  type        = string
  description = "cluster name"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "mongodb_major_ver" {
  type        = number
  default     = 4.4
  description = "mongodb major version"
}

variable "cluster_type" {
  type        = string
  description = "Instance cluster type to use when creating the cluster"
}

variable "num_shards" {
  type        = number
  default     = 1
  description = "number of mongodb shards"
}

variable "replication_factor" {
  type        = number
  description = "number of mongodb replication factor"
}

variable "provider_backup" {
  type        = bool
  default     = true
  description = "Using provider backup"
}

variable "pit_enabled" {
  type        = bool
  default     = false
  description = "Using pit"
}

variable "aws_account_id" {
  type        = string
  default     = ""
  description = "aws account id"
}

variable "vpc_region" {
  type        = string
  default     = ""
  description = "vpc region to using"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "vpc id to using"
}

variable "route_table_cidr_block" {
  type        = string
  default     = ""
  description = "route table cidr block for vpc"
}