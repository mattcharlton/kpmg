resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Project = "kpmg"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Project = "kpmg"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.4.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = false

  tags = {
    Project = "kpmg"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project = "kpmg"
  }
}

resource "aws_route_table" "pub_routetable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Project = "kpmg"
  }
}

resource "aws_route_table_association" "route_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.pub_routetable.id
}
