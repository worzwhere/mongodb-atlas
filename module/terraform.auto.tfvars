provider_region = "ap-southeast-1"

project_name = "ProjectAWS"
org_id       = "600e338d7f47a8219b92570e"

#users = ["example@mail.io", "user@mail.io"]
role = "GROUP_OWNER"
white_lists = "0.0.0.0/32"
  
cluster_region = "AP_SOUTHEAST_1"
cluster_name = "MyCluster"
instance_type      = "M30"
mongodb_major_ver  = 4.4
cluster_type       = "REPLICASET"
num_shards         = 1
replication_factor = 3
provider_backup    = true
pit_enabled        = false

aws_account_id = "956744197313"
vpc_region = "eu-west-1"
vpc_id = "vpc-71468408"
route_table_cidr_block = "172.31.0.0/16"