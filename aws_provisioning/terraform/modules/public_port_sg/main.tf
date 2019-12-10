/**
 * Security Group for Port Access from public
 */
resource "aws_security_group" "sg" {
  name                              = "${var.name}-${var.vpc_id}"
  vpc_id                            = var.vpc_id

  ingress {
    from_port                       = var.port
    to_port                         = var.port
    protocol                        = "tcp"
    cidr_blocks                     = ["0.0.0.0/0"]
  }

  tags = {
    Name                                  = "${var.name}-${var.vpc_id}"
  }
}
