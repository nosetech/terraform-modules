output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnets" {
  value = aws_subnet.public_subnet.*
}
output "private_subnets" {
  value = aws_subnet.private_subnet.*
}
output "public_RT_id" {
  value = aws_default_route_table.public_RT.id
}
output "private_RT_id" {
  value = aws_route_table.private_RT.id
}
output "default_sg_id" {
  value = aws_default_security_group.main.id
}
output "frontend_sg_id" {
  value = aws_security_group.frontend_sg.id
}
output "backend_sg_id" {
  value = aws_security_group.backend_sg.id
}