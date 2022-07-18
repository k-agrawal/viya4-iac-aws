# This is customized based on - https://github.com/terraform-aws-modules/terraform-aws-vpc

locals {
  vpc_id           = data.aws_vpc.vpc[0].id
  existing_subnets = length(var.existing_subnet_ids) > 0 ? true : false

  private_subnets = local.existing_subnets ? data.aws_subnet.private : []

}

data "aws_vpc" "vpc" {
  count = var.vpc_id == null ? 0 : 1
  id    = var.vpc_id
}

######
# VPC
######
resource "aws_vpc_endpoint" "private_endpoints" {
  count              = length(var.vpc_private_endpoints)
  vpc_id             = local.vpc_id
  service_name       = "com.amazonaws.${var.region}.${var.vpc_private_endpoints[count.index]}"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [var.security_group_id]

  tags = merge(
    {
      "Name" = format("%s", "${var.name}-private-endpoint-${var.vpc_private_endpoints[count.index]}")
    },
    var.tags,
  )

  subnet_ids = [
    for subnet in local.private_subnets : subnet.id
  ]
}

data "aws_subnet" "private" {
  count = local.existing_subnets ? length(var.existing_subnet_ids) : 0
  id    = element(var.existing_subnet_ids, count.index)
}

