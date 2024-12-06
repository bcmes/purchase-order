output "vpc_id" {
  value = aws_vpc.my-vpc.id
}
 output "my_subnets_ids" {
   value = aws_subnet.my-subnet[*].id
 }