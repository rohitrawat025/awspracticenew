resource "aws_vpc" "vpca" {
  cidr_block           = "10.0.0.0/16"

  tags = { Name = "vpca" }
}
resource "aws_internet_gateway" "igwa" {
  vpc_id = aws_vpc.vpca.id
}

resource "aws_subnet" "pubsuba" {
  vpc_id     = aws_vpc.vpca.id
  cidr_block = var.subnetpub_cidr
  tags = {
    Name = "pubsuba"
  }
}

resource "aws_route_table" "rttblpuba" {
  vpc_id = aws_vpc.vpca.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igwa.id
  }

  tags = {
    Name = "rttblpuba"
  }
}

resource "aws_eip" "elasticip1a" {
  instance = aws_instance.ec2a.id
}

resource "aws_instance" "ec2a" {
  subnet_id = aws_subnet.pubsuba.id
  vpc_security_group_ids = [aws_security_group.sga.id]
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type

  tags = {
    Name = "ec2a"
  }
}
resource "aws_security_group" "sga" {
  vpc_id      = aws_vpc.vpca.id
ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sga"
  }
}