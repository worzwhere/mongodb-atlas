terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "0.8.0"
    }
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.provider_region
}

provider "mongodbatlas" {}


module "atlas_cluster" {
  source = "../"

  project_name = var.project_name
  org_id       = var.org_id

  # teams = {
  #   Devops : {
  #     users : var.users
  #     role : var.role
  #   }
  # }

  white_lists = {
    "example comment" = var.white_lists
  }

  region = var.cluster_region

  cluster_name = var.cluster_name

  instance_type      = var.instance_type
  mongodb_major_ver  = var.mongodb_major_ver
  cluster_type       = var.cluster_type
  num_shards         = var.num_shards
  replication_factor = var.replication_factor
  provider_backup    = var.provider_backup
  pit_enabled        = var.pit_enabled

  vpc_peer = {
    vpc_peer1 = {
      aws_account_id = var.aws_account_id
      region = var.vpc_region
      vpc_id = var.vpc_id
      route_table_cidr_block = var.route_table_cidr_block
    }
  }

}
