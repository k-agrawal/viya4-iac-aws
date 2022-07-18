#vpc_id
output "vpc_id" {
  description = "VPC id"
  value       = local.vpc_id
}

#subnet_ids
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = data.aws_subnet.private.*.id
}

output "private_subnet_azs" {
  description = "List of private subnet AZs"
  value       = data.aws_subnet.private.*.availability_zone
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = data.aws_subnet.private.*.cidr_block
}

output "vpc_cidr" {
  description = "CIDR block of VPC"
  value       = data.aws_vpc.vpc[0].cidr_block
}
