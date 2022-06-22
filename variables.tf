variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-2"
}

variable "vApp" {
  type    = string
  default = "rlv"
}
