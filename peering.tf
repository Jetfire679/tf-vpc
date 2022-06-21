

data "aws_ssm_parameter" "rlv-VpcId-east1" {
  name = "rlv-VpcId"
  provider = aws.east-1
}

data "aws_ssm_parameter" "rlv-VpcId-east2" {
  name = "rlv-VpcId"
  provider = aws.east-2
}

resource "aws_vpc_peering_connection" "primary2secondary" {
  # Main VPC ID.
  vpc_id = data.aws_ssm_parameter.rlv-VpcId-east2.value

  # AWS Account ID. This can be dynamically queried using the
  # aws_caller_identity data resource.
  # https://www.terraform.io/docs/providers/aws/d/caller_identity.html
  peer_owner_id = data.aws_caller_identity.current.account_id

  # Secondary VPC ID.
  peer_vpc_id = data.aws_ssm_parameter.rlv-VpcId-east1.value

  # Flags that the peering connection should be automatically confirmed. This
  # only works if both VPCs are owned by the same account.
  auto_accept = true
}

resource "aws_route" "primary2secondary" {
  # ID of VPC 1 main route table.
  route_table_id = module.vpc-east-1.vpc_main_route_table_id 

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = module.vpc-east-2.vpc_cidr_block

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
}

resource "aws_route" "secondary2primary" {
  # ID of VPC 2 main route table.
  route_table_id = module.vpc-east-2.vpc_main_route_table_id 

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = module.vpc-east-1.vpc_cidr_block

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
}