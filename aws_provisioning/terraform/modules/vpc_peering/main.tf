/**
 * VPC peering connection.
 *
 * Establishes a relationship resource between the "requester" and "accepter" VPC.
 */
resource "aws_vpc_peering_connection" "requester2accepter" {
  peer_owner_id = var.account_id
  peer_vpc_id   = var.accepter_id
  vpc_id        = var.requester_id
  auto_accept = true

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }

  tags = {
    Name = var.connection_name
  }
}

/**
 * Route rule.
 *
 * Creates a new route rule on the "requester" VPC main route table. All requests
 * to the "accepter" VPC's IP range will be directed to the VPC peering
 * connection.
 */
resource "aws_route" "requester2accepter" {
  route_table_id = var.requester_main_route_table_id
  destination_cidr_block = var.accepter_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester2accepter.id
}

/**
 * Route rule.
 *
 * Creates a new route rule on the "accepting" VPC main route table. All
 * requests to the "requesting" VPC's IP range will be directed to the VPC
 * peering connection.
 */
resource "aws_route" "accepter2requester" {
  route_table_id = var.accepter_main_route_table_id
  destination_cidr_block = var.requester_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester2accepter.id
}
