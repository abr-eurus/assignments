# ================================================= Module-Network =================================================
output "id_vpc" {
  value = module.networkModule.id_vpc
}

output "id_subnet_private" {
  value = module.networkModule.id_subnet_private
}

output "id_subnets_public" {
  value = module.networkModule.id_subnets_public
}

output "id_securityGroup_public" {
  value = module.networkModule.id_sg_public
}

output "id_securityGroup_private" {
  value = module.networkModule.id_sg_private
}

# ================================================= Module-s3 =================================================
output "object_URL" {
  value = module.s3Module.object_URL
}

# ================================================= Module-instance =================================================
output "IP_instance_private" {
  value = module.instanceModule.IP_instance_private
}

# output "instance_public" {
#   value = module.instanceModule.instance_public
# }


output "DNS_loadBalancer" {
  value = module.lbModule.dns_loadBalancer
}