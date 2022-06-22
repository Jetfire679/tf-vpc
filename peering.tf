variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default = ["us-east-2a", "us-east-2b"]
}

variable "requestor_vpc_cidr" {
  type        = string
  description = "Requestor VPC CIDR"
}

variable "acceptor_vpc_cidr" {
  type        = string
  description = "Acceptor VPC CIDR"
}

module "requestor_vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.18.1"
  attributes = ["requestor"]
  cidr_block = var.requestor_vpc_cidr

  context = module.this.context
}

module "requestor_subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.33.0"
  availability_zones   = var.availability_zones
  attributes           = ["requestor"]
  vpc_id               = module.requestor_vpc.vpc_id
  igw_id               = module.requestor_vpc.igw_id
  cidr_block           = module.requestor_vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "acceptor_vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.18.1"
  attributes = ["acceptor"]
  cidr_block = var.acceptor_vpc_cidr

  context = module.this.context
}

module "acceptor_subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.33.0"
  availability_zones   = var.availability_zones
  attributes           = ["acceptor"]
  vpc_id               = module.acceptor_vpc.vpc_id
  igw_id               = module.acceptor_vpc.igw_id
  cidr_block           = module.acceptor_vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "vpc_peering" {
  source                                    = "../.."
  auto_accept                               = true
  requestor_allow_remote_vpc_dns_resolution = true
  acceptor_allow_remote_vpc_dns_resolution  = true
  requestor_vpc_id                          = module.requestor_vpc.vpc_id
  acceptor_vpc_id                           = module.acceptor_vpc.vpc_id
  create_timeout                            = "5m"
  update_timeout                            = "5m"
  delete_timeout                            = "10m"

  context = module.this.context
}




























# data "aws_caller_identity" "current" {}

# resource "aws_vpc_peering_connection" "primary2secondary" {
#   # Main VPC ID.
#   vpc_id = module.vpc-east-1.vpc_id

#   provider = aws.east-1

#   # AWS Account ID. This can be dynamically queried using the
#   # aws_caller_identity data resource.
#   # https://www.terraform.io/docs/providers/aws/d/caller_identity.html
#   peer_owner_id = data.aws_caller_identity.current.account_id

#   # Secondary VPC ID.
#   peer_vpc_id = module.vpc-east-2.vpc_id

#   # Flags that the peering connection should be automatically confirmed. This
#   # only works if both VPCs are owned by the same account.
#   auto_accept = true
# }





# resource "aws_route" "primary2secondary" {
#   # ID of VPC 1 main route table.
#   route_table_id = module.vpc-east-1.vpc_main_route_table_id 

#   provider = aws.east-2

#   # CIDR block / IP range for VPC 2.
#   destination_cidr_block = module.vpc-east-2.vpc_cidr_block

#   # ID of VPC peering connection.
#   vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
# }





# resource "aws_route" "secondary2primary" {
#   # ID of VPC 2 main route table.
#   route_table_id = module.vpc-east-2.vpc_main_route_table_id 

#   provider = aws.east-1

#   # CIDR block / IP range for VPC 2.
#   destination_cidr_block = module.vpc-east-1.vpc_cidr_block

#   # ID of VPC peering connection.
#   vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
# }