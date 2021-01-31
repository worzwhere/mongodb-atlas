# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE THE MONGODB ATLAS PROVIDER
# ---------------------------------------------------------------------------------------------------------------------

#create vars.auto.tf with the following content
mongodb_atlas_username = ""
mongodb_atlas_api_key = ""

# ---------------------------------------------------------------------------------------------------------------------
# resource "mongodbatlas_cluster" "sandboxCluster" 
# ---------------------------------------------------------------------------------------------------------------------
#mongodbatlas_project.project.id
#local.cloud_provider
region = ""
cluster_name = ""
instance_type = ""
mongodb_major_ver = ""
cluster_type = ""
num_shards = ""
replication_factor = ""
provider_backup = ""
pit_enabled = ""
disk_size_gb = ""
auto_scaling_disk_gb_enabled = ""
volume_type = ""
provider_disk_iops = ""
provider_encrypt_ebs_volume = ""

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AWS PEER REQUESTS TO AWS VPC
# ---------------------------------------------------------------------------------------------------------------------

for_each = var.vpc_peer

accepter_region_name   = each.value.region
project_id             = mongodbatlas_project.project.id
container_id           = mongodbatlas_cluster.cluster.container_id
provider_name          = local.cloud_provider
route_table_cidr_block = each.value.route_table_cidr_block
vpc_id                 = each.value.vpc_id
aws_account_id         = each.value.aws_account_id
