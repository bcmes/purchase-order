# Create a VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.prefix}-vpc-example"
  }
}

data "aws_availability_zones" "available" {}
# output "az" {
#   value = data.aws_availability_zones.available.names
# }

# resource "aws_subnet" "my-subnet-1" {
#   vpc_id            = aws_vpc.my-vpc.id
#   cidr_block        = "10.0.0.0/24"
#   availability_zone = "us-east-1a"
#
#   tags = {
#     Name = "${var.prefix}-subnet-example-1"
#   }
# }
#
# resource "aws_subnet" "my-subnet-2" {
#   vpc_id            = aws_vpc.my-vpc.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1b"
#
#   tags = {
#     Name = "${var.prefix}-subnet-example-2"
#   }
# }

resource "aws_subnet" "my-subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true #todo recurso dentro dessas subnets já gera um IP publico

  tags = {
    Name = "${var.prefix}-subnet-example-${count.index + 1}"
  }
}