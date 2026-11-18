provider "aws" {
  region = var.region
}

locals {
  project_name_prefix = "${var.env}-${var.project_name}"

  common_tags = {
    Environment = "${var.env}"
    Owner = "${var.owner}"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = element(var.cidr_blocks, 0)
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.project_name_prefix}-vpc"
  })
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.cidr_blocks, 1)
  availability_zone = element(var.availability_zones, 0)

  tags = merge(local.common_tags, {
    Name = "${local.project_name_prefix}-subnet_public"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.project_name_prefix}-igw"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name_prefix}-route_table_public"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_tls" {
  name = "${local.project_name_prefix}-allow_tls"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name_prefix}-allow_tls"
  })
}

resource "aws_instance" "demo" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = lookup(var.instance_types, var.env, "t3.micro")
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = aws_subnet.public.id

  tags = merge(local.common_tags, {
    Name = "${local.project_name_prefix}-instance"
  })
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.demo.id
  domain   = "vpc"

  tags = merge(local.common_tags, {
    Name = "${local.project_name_prefix}-public_ip"
  })
}
