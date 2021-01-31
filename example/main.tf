provider "aws" {
  region = "eu-west-1"
}

provider "mongodbatlas" {
  username = ""
  api_key = ""
}

module "atlas_cluster" {
  source = "../../"

  project_name = "Project"
  org_id       = "600e338d7f47a8219b92570e"

#   teams = {
#     Devops : {
#       users : ["example@mail.io", "user@mail.io"]
#       role : "GROUP_OWNER"
#     },
#     DevTeam : {
#       users : ["developer@mail.io"]
#       role : "GROUP_READ_ONLY"
#     }
#   }

  white_lists = {
    "example comment" : "0.0.0.0/32",
  }

  region = "EU_WEST_1"

  cluster_name = "MyAtlasCluster"

  instance_type      = "M30"
  mongodb_major_ver  = 4.2
  cluster_type       = "REPLICASET"
  num_shards         = 1
  replication_factor = 3
  provider_backup    = true
  pit_enabled        = false

  vpc_peer = {
    vpc_peer1 : {
      aws_account_id : "956744197313"
      region : "eu-west-1"
      vpc_id : "vpc-71468408"
      route_table_cidr_block : "172.31.0.0/16"
    }
  }

}
