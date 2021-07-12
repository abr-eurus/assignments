
module "networkModule" {
  source          = "./modules/network"
  TAG_NAME_PREFIX = var.GLOBAL__TAG_NAME_PREFIX
  REGION          = var.REGION
  AZs = local.AZs
  CIDR_VPC        = var.CIDR_VPC
  ALLOW_PUBLIC_SUBNETS = var.ALLOW_PUBLIC_SUBNETS
  SG_INGRESS_RULES__PUBLIC = var.SG_INGRESS_RULES__PUBLIC
  SG_INGRESS_RULES__LB = var.SG_INGRESS_RULES__LB
}

module "s3Module" {
  source          = "./modules/s3"
  TAG_NAME_PREFIX = var.GLOBAL__TAG_NAME_PREFIX
  BUCKET = var.BUCKET
}

module "lbModule" {
  source          = "./modules/load-balancing"
  TAG_NAME_PREFIX = var.GLOBAL__TAG_NAME_PREFIX
  AZs = local.AZs
  SUBNETS__PUBLIC = module.networkModule.id_subnets_public
  ID_VPC = module.networkModule.id_vpc
  SECURITY_GROUP__LB = module.networkModule.id_sg_load_balancer
}

module "instanceModule" {
  source          = "./modules/instance"
  TAG_NAME_PREFIX = var.GLOBAL__TAG_NAME_PREFIX
  REGION          = var.REGION
  AZs = local.AZs
  INSTANCE = var.INSTANCE
  OBJ_URL = module.s3Module.object_URL
  SECURITY_GROUP__PUBLIC = module.networkModule.id_sg_public
  SECURITY_GROUP__PRIVATE = module.networkModule.id_sg_private
  SUBNET__PRIVATE = module.networkModule.id_subnet_private
  SUBNETS__PUBLIC = module.networkModule.id_subnets_public
  # DEPENDENCIES = [module.s3Module.bucket_obj]
}

module "autoScalingModule" {
  source = "./modules/auto-scaling"
  TAG_NAME_PREFIX = var.GLOBAL__TAG_NAME_PREFIX
  SECURITY_GROUP__PUBLIC = module.networkModule.id_sg_public
  SUBNETS__PUBLIC = module.networkModule.id_subnets_public
  INSTANCE = var.INSTANCE
  PRIVATE_INSTANCE = module.instanceModule.IP_instance_private
  OBJ_URL = module.s3Module.object_URL
  TARGET_GROUP__ARN = module.lbModule.arn_targetGroup
  DEPENDENCIES = [
    module.s3Module.bucket_obj,
    module.instanceModule.instance_private
  ]
}