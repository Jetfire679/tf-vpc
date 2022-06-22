# provider.tf

# Specify the provider and access details
provider "aws" {
  region                  = var.aws_region
}

provider "aws" {
  region  = "us-east-2"
  alias = "east-2"
}

provider "aws" {
  region  = "us-east-1"
  alias = "east-1"
}