# Create a VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.prefix}-vpc-example"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "my-subnet" {
  count             = 2
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true #todo recurso dentro dessas subnets já gera um IP publico

  tags = {
    Name = "${var.prefix}-subnet-example-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "my-ig" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-internet-gateway"
  }
}

resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-ig.id
  }
  tags = {
    Name = "my-route-table"
  }
}

resource "aws_route_table_association" "my-rta" {
  count          = 2
  subnet_id      = aws_subnet.my-subnet.*.id[count.index]
  route_table_id = aws_route_table.my-rt.id
}