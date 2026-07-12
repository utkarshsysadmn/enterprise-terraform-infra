variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 CIDR"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "Public Subnet 2 CIDR"
  type        = string
}

variable "availability_zone_1" {
  description = "Availability Zone for Public Subnet 1"
  type        = string
}

variable "availability_zone_2" {
  description = "Availability Zone for Public Subnet 2"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 CIDR"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 CIDR"
  type        = string
}

variable "tags" {
  description = "Resource Tags"
  type        = map(string)
  default     = {}
}