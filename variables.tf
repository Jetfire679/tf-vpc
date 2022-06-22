variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-2"
}

variable "vApp" {
  type    = string
  default = "rlv"
}

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
  default = module.vpc-east-2.vpc_cidr_block
}

variable "acceptor_vpc_cidr" {
  type        = string
  description = "Acceptor VPC CIDR"
  default = module.vpc-east-1.vpc_cidr_block
}