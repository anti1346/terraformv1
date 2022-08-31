variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "ap-northeast-2"
}

variable "name" {
  description = "vpc name"
  type        = string
  default     = "vpc10"
}

variable "cidr" {
  description = "vpc cidr"
  type        = string
  default     = "10.10.0.0/16"
}



################################################################################
################################################################################
################################################################################
variable "azs" {
  description = "Availability zone for VPC"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]

}

variable "public_subnets" {
  description = "public subnets for vpc"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]

}

variable "private_subnets" {
  description = "private subnets for vpc"
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24"]

}

variable "database_subnets" {
  description = "public subnets for vpc"
  type        = list(string)
  default     = ["10.10.201.0/24", "10.10.202.0/24"]

}


################################################################################
################################################################################
################################################################################
variable "project_name" {
  description = "project name"
  default     = "my_project"
}

variable "environment" {
  description = "Environment : development | testing | staging | production "
  default     = "development"
}

variable "owner" {
  description = "owner name"
  type        = string
  default     = "oadmin"
}

################################################################################
################################################################################
################################################################################
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}
