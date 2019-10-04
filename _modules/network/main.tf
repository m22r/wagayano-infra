resource "aws_subnet" "subnet" {
  count             = length(var.availability_zones)
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.newbits, count.index + var.netnum_offset)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.prefix}-${var.type}-${substr(var.availability_zones[count.index], -2, 2)}"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.type == "private" ? length(aws_subnet.subnet) : 0
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = var.private_route_table_ids[count.index]
}

resource "aws_route_table_association" "public" {
  count          = var.type == "public" ? length(aws_subnet.subnet) : 0
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = var.public_route_table_id
}

resource "aws_security_group" "group" {
  name   = "${var.prefix}-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
