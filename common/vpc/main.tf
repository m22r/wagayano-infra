## VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

## Gateways
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

## Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.prefix}-public-rt"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat[count.index % length(aws_instance.nat)].id
  }

  tags = {
    Name = "${var.prefix}-private-rt-${substr(var.availability_zones[count.index], -2, 2)}"
  }
}

## Subnets
resource "aws_subnet" "nat" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 10, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.prefix}-nat-public-${substr(var.availability_zones[count.index], -2, 2)}"
    Role = "nat"
  }
}

resource "aws_route_table_association" "nat" {
  count          = length(aws_subnet.nat)
  subnet_id      = aws_subnet.nat[count.index].id
  route_table_id = aws_route_table.public.id
}

## Security Groups
resource "aws_security_group" "common" {
  name   = "${var.prefix}-common-sg"
  vpc_id = aws_vpc.main.id

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

resource "aws_security_group" "nat" {
  name   = "${var.prefix}-nat-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.common.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## NAT Instance
data "aws_ami_ids" "nat" {
  owners         = ["amazon"]
  sort_ascending = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "nat" {
  count                       = var.nat_instance_num
  ami                         = data.aws_ami_ids.nat.ids[length(data.aws_ami_ids.nat.ids) - 1]
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.nat[count.index].id
  vpc_security_group_ids      = [aws_security_group.nat.id]
  associate_public_ip_address = true
  source_dest_check           = false
  tags = {
    Name = "${var.prefix}-nat-${substr(var.availability_zones[count.index], -2, 2)}"
  }
}
