/**
 * VPC
 */
resource "aws_vpc" "main" {
  cidr_block                              = var.cidr
  enable_dns_support                      = var.dns_support
  enable_dns_hostnames                    = var.dns_hostnames

  tags = {
    Name                                  = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.name}"
    Environment                           = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.environment}"
  }
}

/**
 * Create an Internet Gateway, if public_subnets are set
 */
resource "aws_internet_gateway" "gw" {
  vpc_id                                  = aws_vpc.main.id
  count                                   = length(var.public_subnets) > 0 ? 1 : 0
}

/**
 * Add Internet Route to gateway, if public_subnets are set
 */
resource "aws_route" "internet_access" {
  route_table_id                          = aws_vpc.main.main_route_table_id
  destination_cidr_block                  = "0.0.0.0/0"
  gateway_id                              = aws_internet_gateway.gw.0.id
  count                                   = length(var.public_subnets) > 0 ? 1 : 0
}


/**
 * Private Subnets
 */
resource "aws_subnet" "private_subnets" {
  vpc_id                                  = aws_vpc.main.id
  cidr_block                              = lookup(var.private_subnets, element(var.availability_zones, count.index))
  availability_zone                       = element(var.availability_zones, count.index)
  count                                   = length(var.private_subnets)

  tags = {
    Name                                  = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.name}-${format("private_subnet-%03d", count.index+1)}"
    Environment                           = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.environment}"
  }
}

/**
 * Public Subnets
 */
resource "aws_subnet" "public_subnets" {
  vpc_id                                  = aws_vpc.main.id
  cidr_block                              = lookup(var.public_subnets, element(var.availability_zones, count.index))
  availability_zone                       = element(var.availability_zones, count.index)
  map_public_ip_on_launch                 = true
  depends_on                              = [aws_internet_gateway.gw]
  count                                   = length(var.public_subnets)

  tags = {
    Name                                  = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.name}-${format("public_subnet-%03d", count.index+1)}"
    Environment                           = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.environment}"
  }
}

/**
 * Set Name for Routing Table
 */
resource "aws_default_route_table" "r" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.name}"
    Environment = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.environment}"
  }
}

/**
 * Security Group for internet egress
 */
resource "aws_security_group" "egress-internet" {
  name                              = "${var.prefix == "" ? "" : format("%s-", var.prefix) }egress-internet-${aws_vpc.main.id}"
  vpc_id                            = aws_vpc.main.id

  ingress {
    from_port                       = 8
    to_port                         = "-1"
    protocol                        = "icmp"
    cidr_blocks                     = ["10.0.0.0/8"]
  }

  egress {
    from_port                       = 0
    to_port                         = 0
    protocol                        = "-1"
    cidr_blocks                     = ["0.0.0.0/0"]
  }

  tags = {
    Name                                  = "${var.prefix == "" ? "" : format("%s-", var.prefix) }egress-internet-${aws_vpc.main.id}"
  }
}
