# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "0.8.0"
    }
  }
  required_version = ">= 0.12"
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE THE MONGODB ATLAS PROVIDER
# ---------------------------------------------------------------------------------------------------------------------

#create vars.auto.tf with the following content
variable "mongodb_atlas_username" {}
variable "mongodb_atlas_api_key" {}

provider "mongodbatlas" {
  username = "${var.mongodb_atlas_username}"
  api_key = "${var.mongodb_atlas_api_key}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ATLAS PROJECT THAT THE CLUSTER WILL RUN INSIDE
# ---------------------------------------------------------------------------------------------------------------------

resource "mongodbatlas_project" "project" {
  name   = var.project_name
  org_id = var.org_id

  #Associate teams and privileges if passed, if not - run with an empty object
  dynamic "teams" {
    for_each = var.teams

    content {
      team_id    = mongodbatlas_teams.team[teams.key].team_id
      role_names = [teams.value.role]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE TEAMS FROM **EXISTING USERS**
# ---------------------------------------------------------------------------------------------------------------------

resource "mongodbatlas_teams" "team" {
  for_each = var.teams

  org_id    = var.org_id
  name      = each.key
  usernames = each.value.users
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE NETWORK WHITE-LISTS FOR ACCESSING THE PROJECT
# ---------------------------------------------------------------------------------------------------------------------

#Optionall, if no variable is passed, the loop will run on an empty object.

resource "mongodbatlas_project_ip_whitelist" "whitelists" {
  for_each = var.white_lists

  project_id = mongodbatlas_project.project.id
  comment    = each.key
  cidr_block = each.value
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB ATLAS CLUSTER IN THE PROJECT
# ---------------------------------------------------------------------------------------------------------------------

resource "mongodbatlas_cluster" "sandboxCluster" {
  project_id                   = mongodbatlas_project.project.id
  provider_name                = local.cloud_provider
  provider_region_name         = var.region
  name                         = var.cluster_name
  provider_instance_size_name  = var.instance_type
  mongo_db_major_version       = var.mongodb_major_ver
  cluster_type                 = var.cluster_type
  num_shards                   = var.num_shards
  replication_factor           = var.replication_factor
  provider_backup_enabled      = var.provider_backup
  pit_enabled                  = var.pit_enabled
  disk_size_gb                 = var.disk_size_gb
  auto_scaling_disk_gb_enabled = var.auto_scaling_disk_gb_enabled
  provider_volume_type         = var.volume_type
  provider_disk_iops           = var.provider_disk_iops
  provider_encrypt_ebs_volume  = var.provider_encrypt_ebs_volume
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AWS PEER REQUESTS TO AWS VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "mongodbatlas_network_peering" "mongo_peer" {
  for_each = var.vpc_peer

  accepter_region_name   = each.value.region
  project_id             = mongodbatlas_project.project.id
  container_id           = mongodbatlas_cluster.cluster.container_id
  provider_name          = local.cloud_provider
  route_table_cidr_block = each.value.route_table_cidr_block
  vpc_id                 = each.value.vpc_id
  aws_account_id         = each.value.aws_account_id
}

# ---------------------------------------------------------------------------------------------------------------------
# ACCEPT THE PEER REQUESTS ON THE AWS SIDE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc_peering_connection_accepter" "peer" {
  for_each = var.vpc_peer

  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peer[each.key].connection_id
  auto_accept               = true
}

# ---------------------------------------------------------------------------------------------------------------------
# SNAPSHOT BACKUP POLICIES
# ---------------------------------------------------------------------------------------------------------------------

resource "mongodbatlas_cloud_provider_snapshot_backup_policy" "testCluster" {
  project_id   = mongodbatlas_cluster.sandboxCluster.project_id
  cluster_name = mongodbatlas_cluster.sandboxCluster.name

  reference_hour_of_day    = 3
  reference_minute_of_hour = 45
  restore_window_days      = 4


  policies {
    id = mongodbatlas_cluster.sandboxCluster.snapshot_backup_policy.0.policies.0.id

    policy_item {
      id                 = mongodbatlas_cluster.sandboxCluster.snapshot_backup_policy.0.policies.0.policy_item.0.id
      frequency_interval = 1
      frequency_type     = "hourly"
      retention_unit     = "days"
      retention_value    = 1
    }
    policy_item {
      id                 = mongodbatlas_cluster.sandboxCluster.snapshot_backup_policy.0.policies.0.policy_item.1.id
      frequency_interval = 1
      frequency_type     = "daily"
      retention_unit     = "days"
      retention_value    = 2
    }
    policy_item {
      id                 = mongodbatlas_cluster.sandboxCluster.snapshot_backup_policy.0.policies.0.policy_item.2.id
      frequency_interval = 4
      frequency_type     = "weekly"
      retention_unit     = "weeks"
      retention_value    = 3
    }
    policy_item {
      id                 = mongodbatlas_cluster.sandboxCluster.snapshot_backup_policy.0.policies.0.policy_item.3.id
      frequency_interval = 5
      frequency_type     = "monthly"
      retention_unit     = "months"
      retention_value    = 4
    }
  }
}

data "mongodbatlas_cloud_provider_snapshot_backup_policy" "testCluster" {
  project_id   = mongodbatlas_cloud_provider_snapshot_backup_policy.testCluster.project_id
  cluster_name = mongodbatlas_cloud_provider_snapshot_backup_policy.testCluster.cluster_name
}