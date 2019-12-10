/**
 * Output Variables
 */

// The VPC ID
output "id" {
  value = aws_vpc.main.id
}

// The VPC main route table id
output "main-route-table-id" {
  value = aws_vpc.main.main_route_table_id
}

// The VPC default network acl id
output "default-network-acl-id" {
  value = aws_vpc.main.default_network_acl_id
}

// A comma-separated list of subnet IDs.
output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

// A comma-separated list of subnet IDs.
output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

// Internet Gateway ID.
output "gateway_id" {
  value = join("", aws_internet_gateway.gw.*.id)
}

// Internet egress SecurityGroup ID.
output "egress_sg_id" {
  value = aws_security_group.egress-internet.id
}
