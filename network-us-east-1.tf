

module "vpc-east-1" {
  source = "terraform-aws-modules/vpc/aws"
  # providers = {
  #   aws = aws.east-1
  #  }
  provider = aws.east-1

  name = join("-", [var.vApp,"vpc-east-1"])
  cidr = "10.1.0.0/16"



  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["10.1.0.0/24","10.1.1.0/24","10.1.2.0/24"]
  # private_subnets = ["10.0.10.0/24","10.0.20.0/24","10.0.30.0/24"]

  # enable_nat_gateway = true
  # enable_vpn_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs-east-1" {
  state = "available"
  provider = aws.east-1
}


resource "aws_ssm_parameter" "public_subnet_id_a-east-1" {
  name  = join("-", [var.vApp, "PubSubA_ID"])
  type  = "String"
  value = module.vpc-east-1.public_subnets[0]
  provider = aws.east-1
}

resource "aws_ssm_parameter" "public_subnet_id_b-east-1" {
  name  = join("-", [var.vApp, "PubSubB_ID"])
  type  = "String"
  value = module.vpc-east-1.public_subnets[1]
  provider = aws.east-1
}

resource "aws_ssm_parameter" "public_subnet_id_c-east-1" {
  name  = join("-", [var.vApp, "PubSubC_ID"])
  type  = "String"
  value = module.vpc-east-1.public_subnets[2]
  provider = aws.east-1
}

resource "aws_ssm_parameter" "public_subnet_a-east-1" {
  name  = join("-", [var.vApp, "PubSubA"])
  type  = "String"
  value = module.vpc-east-1.public_subnets_cidr_blocks[0]
  provider = aws.east-1
}

resource "aws_ssm_parameter" "public_subnet_b-east-1" {
  name  = join("-", [var.vApp, "PubSubB"])
  type  = "String"
  value = module.vpc-east-1.public_subnets_cidr_blocks[1]
  provider = aws.east-1
}

resource "aws_ssm_parameter" "public_subnet_c-east-1" {
  name  = join("-", [var.vApp, "PubSubC"])
  type  = "String"
  value = module.vpc-east-1.public_subnets_cidr_blocks[2]
  provider = aws.east-1
}

resource "aws_ssm_parameter" "vpc_id-east-1" {
  name  = join("-", [var.vApp, "VpcId"])
  type  = "String"
  value = module.vpc-east-1.vpc_id
  provider = aws.east-1
}