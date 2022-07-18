## Global
variable "prefix" {
  description = "A prefix used in the name for all cloud resources created by this script. The prefix string must start with a lowercase letter and contain only alphanumeric characters and hyphens or dashes (-), but cannot start or end with '-'."
  type        = string

  validation {
    condition     = can(regex("^[a-z][-0-9a-z]*[0-9a-z]$", var.prefix))
    error_message = "ERROR: Value of 'prefix'\n * must start with lowercase letter\n * can only contain lowercase letters, numbers, hyphens, or dashes (-), but cannot start or end with '-'."
  }
}

## Provider
variable "location" {
  description = "AWS Region to provision all resources in this script"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Name of Profile in the credentials file"
  type        = string
  default     = ""
}

variable "aws_shared_credentials_file" {
  description = "Name of credentials file, if using non-default location"
  type        = string
  default     = ""
}

variable "aws_session_token" {
  description = "Session token for temporary credentials"
  type        = string
  default     = ""
}

variable "aws_access_key_id" {
  description = "Static credential key"
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "Static credential secret"
  type        = string
  default     = ""
}

variable "iac_tooling" {
  description = "Value used to identify the tooling used to generate this provider's infrastructure"
  type        = string
  default     = "terraform"
}

## Private Access
variable "cluster_endpoint_private_access_cidrs" {
  description = "List of CIDRs to access Kubernetes cluster - Private"
  type        = list(string)
  default     = null
}

## Provider Specific 
variable "ssh_public_key" {
  description = "SSH public key used to access VMs"
  default     = "~/.ssh/id_rsa.pub"
}

variable efs_performance_mode {
  default = "generalPurpose"
}

## Kubernetes
variable "kubernetes_version" {
  description = "The EKS cluster Kubernetes version"
  default     = "1.21"
}

variable "tags" {
  description = "Map of common tags to be placed on the resources"
  type        = map
  default     = { project_name = "viya" }

  validation {
    condition     = length(var.tags) > 0
    error_message = "ERROR: You must provide at last one tag."
  }
}

## Default node pool config
variable "create_default_nodepool" {
  description = "Create Default Node Pool"
  type        = bool
  default     = true
}

variable "default_nodepool_vm_type" {
  default = "m5.2xlarge"
}

variable "default_nodepool_os_disk_type" {
  type    = string
  default = "gp2"

  validation {
    condition     = contains(["gp2", "io1"], lower(var.default_nodepool_os_disk_type))
    error_message = "ERROR: Supported values for `default_nodepool_os_disk_type` are gp2, io1."
  }
}

variable "default_nodepool_os_disk_size" {
  default = 200
}

variable "default_nodepool_os_disk_iops" {
  default = 0
}

variable "default_nodepool_node_count" {
  default = 1
}

variable "default_nodepool_max_nodes" {
  default = 5
}

variable "default_nodepool_min_nodes" {
  default = 1
}

variable "default_nodepool_taints" {
  type    = list
  default = []
}

variable "default_nodepool_labels" {
  type = map
  default = {
    "kubernetes.azure.com/mode" = "system"
  }
}

variable "default_nodepool_custom_data" {
  default = ""
}

variable "default_nodepool_metadata_http_endpoint" {
  default = "enabled"
}

variable "default_nodepool_metadata_http_tokens" {
  default = "required"
}

variable "default_nodepool_metadata_http_put_response_hop_limit" {
  default = 1
}

## Dynamic node pool config
variable node_pools {
  description = "Node pool definitions"
  type = map(object({
    vm_type                              = string
    cpu_type                             = string
    os_disk_type                         = string
    os_disk_size                         = number
    os_disk_iops                         = number
    min_nodes                            = number
    max_nodes                            = number
    node_taints                          = list(string)
    node_labels                          = map(string)
    custom_data                          = string
    metadata_http_endpoint               = string
    metadata_http_tokens                 = string
    metadata_http_put_response_hop_limit = number
  }))

  default = {
    cas = {
      "vm_type"      = "m5.2xlarge"
      "cpu_type"     = "AL2_x86_64"
      "os_disk_type" = "gp2"
      "os_disk_size" = 200
      "os_disk_iops" = 0
      "min_nodes"    = 1
      "max_nodes"    = 5
      "node_taints"  = ["workload.sas.com/class=cas:NoSchedule"]
      "node_labels" = {
        "workload.sas.com/class" = "cas"
      }
      "custom_data"                          = ""
      "metadata_http_endpoint"               = "enabled"
      "metadata_http_tokens"                 = "required"
      "metadata_http_put_response_hop_limit" = 1
    },
    compute = {
      "vm_type"      = "m5.8xlarge"
      "cpu_type"     = "AL2_x86_64"
      "os_disk_type" = "gp2"
      "os_disk_size" = 200
      "os_disk_iops" = 0
      "min_nodes"    = 1
      "max_nodes"    = 5
      "node_taints"  = ["workload.sas.com/class=compute:NoSchedule"]
      "node_labels" = {
        "workload.sas.com/class"        = "compute"
        "launcher.sas.com/prepullImage" = "sas-programming-environment"
      }
      "custom_data"                          = ""
      "metadata_http_endpoint"               = "enabled"
      "metadata_http_tokens"                 = "required"
      "metadata_http_put_response_hop_limit" = 1
    },
    stateless = {
      "vm_type"      = "m5.4xlarge"
      "cpu_type"     = "AL2_x86_64"
      "os_disk_type" = "gp2"
      "os_disk_size" = 200
      "os_disk_iops" = 0
      "min_nodes"    = 1
      "max_nodes"    = 5
      "node_taints"  = ["workload.sas.com/class=stateless:NoSchedule"]
      "node_labels" = {
        "workload.sas.com/class" = "stateless"
      }
      "custom_data"                          = ""
      "metadata_http_endpoint"               = "enabled"
      "metadata_http_tokens"                 = "required"
      "metadata_http_put_response_hop_limit" = 1
    },
    stateful = {
      "vm_type"      = "m5.4xlarge"
      "cpu_type"     = "AL2_x86_64"
      "os_disk_type" = "gp2"
      "os_disk_size" = 200
      "os_disk_iops" = 0
      "min_nodes"    = 1
      "max_nodes"    = 3
      "node_taints"  = ["workload.sas.com/class=stateful:NoSchedule"]
      "node_labels" = {
        "workload.sas.com/class" = "stateful"
      }
      "custom_data"                          = ""
      "metadata_http_endpoint"               = "enabled"
      "metadata_http_tokens"                 = "required"
      "metadata_http_put_response_hop_limit" = 1
    }
  }
}

# Networking
variable "vpc_id" {
  type        = string
  default     = null
  description = "Pre-exising VPC id. Leave blank to have one created"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of existing subnet ids"
}

variable "security_group_id" {
  type        = string
  default     = null
  description = "Pre-existing Security Group id. Leave blank to have one created"

}

variable "cluster_security_group_id" {
  type        = string
  default     = null
  description = "Pre-existing Security Group id for the EKS Cluster. Leave blank to have one created"
}

variable "workers_security_group_id" {
  type        = string
  default     = null
  description = "Pre-existing Security Group id for the Cluster Node VM. Leave blank to have one created"
}

variable "cluster_iam_role_name" {
  type        = string
  default     = null
  description = "Pre-existing IAM Role for the EKS cluster"
}

variable "workers_iam_role_name" {
  type        = string
  default     = null
  description = "Pre-existing IAM Role for the Node VMs"
}


variable "create_jump_vm" {
  description = "Create bastion host VM"
  default     = true
}

variable "create_jump_public_ip" {
  type    = bool
  default = false
}

variable "jump_vm_admin" {
  description = "OS Admin User for Jump VM"
  default     = "jumpuser"
}

variable "jump_vm_type" {
  description = "Jump VM type"
  default     = "m5.4xlarge"
}

variable "jump_rwx_filestore_path" {
  description = "OS path used in cloud-init for NFS integration"
  default     = "/viya-share"
}

variable "nfs_raid_disk_size" {
  description = "Size in GB for each disk of the RAID0 cluster, when storage_type=standard"
  default     = 128
}

variable "nfs_raid_disk_type" {
  default = "gp2"
}

variable "nfs_raid_disk_iops" {
  default = 0
}

variable "create_nfs_public_ip" {
  type    = bool
  default = false
}

variable "nfs_vm_admin" {
  description = "OS Admin User for NFS VM, when storage_type=standard"
  default     = "nfsuser"
}

variable "nfs_vm_type" {
  description = "NFS VM type"
  default     = "m5.4xlarge"
}

variable "os_disk_size" {
  default = 64
}

variable "os_disk_type" {
  default = "standard"
}

variable "os_disk_delete_on_termination" {
  default = true
}

variable "os_disk_iops" {
  default = 0
}

variable "storage_type" {
  type    = string
  default = "standard"
  # NOTE: storage_type=none is for internal use only
  validation {
    condition     = contains(["standard", "ha", "none"], lower(var.storage_type))
    error_message = "ERROR: Supported values for `storage_type` are standard, ha."
  }
}

variable "create_static_kubeconfig" {
  description = "Allows the user to create a provider- or service account-based kubeconfig file"
  type        = bool
  default     = true
}

variable "cluster_api_mode" {
  description = "Use Public or Private IP address for the cluster API endpoint"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private"], lower(var.cluster_api_mode))
    error_message = "ERROR: Supported values for `cluster_api_mode` are - public, private."
  }
}

variable "vpc_private_endpoints" {
  description = "Endpoints needed for private cluster"
  type        = list(string)
  default     = ["ec2", "ecr.api", "ecr.dkr", "s3", "logs", "sts", "elasticloadbalancing", "autoscaling"]
}

variable "cluster_node_pool_mode" {
  description = "Flag for predefined cluster node configurations. Supported values are default, minimal."
  type        = string
  default     = "default"

}

variable "autoscaling_enabled" {
  description = "Enable autoscaling for your AWS cluster."
  type        = bool
  default     = true
}
