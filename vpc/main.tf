resource "aws_internet_gateway" "ndigw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "ndsnrigw"
  }
}

resource "aws_subnet" "ndpubsub" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr
  availability_zone       = "us-east-1a"
  tags = {
    Name = "ndsnrpubsub"
  }
}

resource "aws_route_table" "ndrttblpub" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.route_table_int_cidr
    gateway_id = aws_internet_gateway.ndigw.id
  }

  tags = {
    Name = "ndsnrrttblpub"
  }
}

resource "aws_route_table_association" "ndpubsubrttblassn" {
  subnet_id      = aws_subnet.ndpubsub.id
  route_table_id = aws_route_table.ndrttblpub.id
}