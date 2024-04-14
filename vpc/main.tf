resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags       = {
        Name = "Qoala VPC"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
}


resource "aws_eip" "nat_eip" {
#   vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet_1.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name        = "nat"
  }
}

resource "aws_subnet" "pub_subnet_1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = var.availability_zone_names[0]
    tags       = {
        Name = "Qoala VPC - Public"
    }
}

resource "aws_subnet" "pub_subnet_2" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.5.0/24"
    availability_zone       = var.availability_zone_names[1]
    tags       = {
        Name = "Qoala VPC - Public"
    }
}


resource "aws_subnet" "private_subnet_1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.3.0/24"
    availability_zone       = var.availability_zone_names[0]
    tags       = {
        Name = "Qoala VPC - Private"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_3" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "qoala_elb" {
  name   = "qoala-sg_for_elb"
  vpc_id = aws_vpc.vpc.id
  
  ingress {
    description      = "Allow http request from anywhere"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}