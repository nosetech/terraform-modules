output "vpc_id" {
    value = module.web_vpc.vpc_id
}
output "public_subnets" {
  value = module.web_vpc.public_subnets
}
output "private_subnets" {
  value = module.web_vpc.private_subnets
}
output "public_RT_id" {
  value = module.web_vpc.public_RT_id
}
output "private_RT_id" {
  value = module.web_vpc.private_RT_id
}
output "default_sg_id" {
  value = module.web_vpc.default_sg_id
}
output "frontend_sg_id" {
  value = module.web_vpc.frontend_sg_id
}
output "backend_sg_id" {
  value = module.web_vpc.backend_sg_id
}
