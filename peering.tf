data "aws_caller_identity" "current" {}

resource "aws_vpc_peering_connection" "requester" {
  provider = aws.east-2
  
  # Main VPC ID.
  vpc_id = module.vpc-east-2.vpc_id
  

  # AWS Account ID. This can be dynamically queried using the
  # aws_caller_identity data resource.
  # https://www.terraform.io/docs/providers/aws/d/caller_identity.html
  peer_owner_id = data.aws_caller_identity.current.account_id

  # Secondary VPC ID.
  peer_vpc_id = module.vpc-east-1.vpc_id

  # Flags that the peering connection should be automatically confirmed. This
  # only works if both VPCs are owned by the same account.
  auto_accept = false
  peer_region   = "us-east-1"
  
  depends_on = [
    module.vpc-east-2
  ]  
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
    provider = aws.east-1
    vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
    auto_accept = true
  
  depends_on = [
    module.vpc-east-1
  ]      
}

resource "aws_route" "secondary2primary" {
  # ID of VPC 1 main route table.
  route_table_id = module.vpc-east-1.vpc_main_route_table_id 

  provider = aws.east-1

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = module.vpc-east-2.vpc_cidr_block

  # ID of VPC peering connection.
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
}





resource "aws_route" "primary2secondary" {
  # ID of VPC 2 main route table.
  route_table_id = module.vpc-east-2.vpc_main_route_table_id 

  provider = aws.east-2

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = module.vpc-east-1.vpc_cidr_block

  # ID of VPC peering connection.
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
}