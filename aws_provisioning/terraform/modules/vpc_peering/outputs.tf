/**
 * Outputs
 */

// Peering Connection ID
output "connection-id" {
  value = aws_vpc_peering_connection.requester2accepter.id
}
