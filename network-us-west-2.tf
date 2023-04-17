# module "vpc-west-2" {
#   source = "terraform-aws-modules/vpc/aws"

#   providers = {
#     aws = aws.west-2
#    }

#   name = join("-", [var.vApp,"vpc-west-2"])
#   cidr = "10.2.0.0/16"



#   azs            = ["us-west-2a", "us-west-2b", "us-west-2c"]
#   public_subnets = ["10.2.0.0/24","10.2.1.0/24","10.2.2.0/24"]
#   # private_subnets = ["10.0.10.0/24","10.0.20.0/24","10.0.30.0/24"]

#   # enable_nat_gateway = true
#   # enable_vpn_gateway = true

#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }

# }

# #Get all available AZ's in VPC for master region
# data "aws_availability_zones" "azs-west-2" {
#   state = "available"
#   provider = aws.west-2
# }


# resource "aws_ssm_parameter" "public_subnet_id_a-west-2" {
#   name  = join("-", [var.vApp, "PubSubA_ID"])
#   type  = "String"
#   value = module.vpc-west-2.public_subnets[0]
#   provider = aws.west-2
# }

# resource "aws_ssm_parameter" "public_subnet_id_b-west-2" {
#   name  = join("-", [var.vApp, "PubSubB_ID"])
#   type  = "String"
#   value = module.vpc-west-2.public_subnets[1]
#   provider = aws.west-2
# }

# resource "aws_ssm_parameter" "public_subnet_id_c-west-2" {
#   name  = join("-", [var.vApp, "PubSubC_ID"])
#   type  = "String"
#   value = module.vpc-west-2.public_subnets[2]
#   provider = aws.west-2
# }

# resource "aws_ssm_parameter" "public_subnet_a-west-2" {
#   name  = join("-", [var.vApp, "PubSubA"])
#   type  = "String"
#   value = module.vpc-west-2.public_subnets_cidr_blocks[0]
#   provider = aws.west-2
# }

# resource "aws_ssm_parameter" "public_subnet_b-west-2" {
#   name  = join("-", [var.vApp, "PubSubB"])
#   type  = "String"
#   value = module.vpc-west-2.public_subnets_cidr_blocks[1]
#   provider = aws.west-2
# }

# resource "aws_ssm_parameter" "public_subnet_c-west-2" {
#   name  = join("-", [var.vApp, "PubSubC"])
#   type  = "String"
#   value = module.vpc-west-2.public_subnets_cidr_blocks[2]
#   provider = aws.west-2
# }

# resource "aws_ssm_parameter" "vpc_id-west-2" {
#   name  = join("-", [var.vApp, "VpcId"])
#   type  = "String"
#   value = module.vpc-west-2.vpc_id
#   provider = aws.west-2
# }