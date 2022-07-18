variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable vpc_id {
  description = "Existing vpc id"
  default     = null
}

variable "name" {
  type    = string
  default = null
}

variable "existing_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Map subnet usage roles to existing list of subnet ids"
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "vpc_private_endpoints" {
  description = "Endpoints needed for private cluster"
  type        = list(string)
  default     = ["ec2", "ecr.api", "ecr.dkr", "s3", "logs", "sts", "elasticloadbalancing", "autoscaling"]
}

variable "region" {
  description = "Region"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}
