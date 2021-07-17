#AWS provider related properties
variable "region" {
  description = "The region of the AWS service."
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "The profile name configured in aws credentials file using aws cli"
  type        = string
  default     = "dev-profile-terraform"
}

#EC2 resource related properties
variable "ami" {
  description = "AMI ID used for all EC2"
  type        = string
  default     = "ami-09e67e426f25ce0d7"
}

variable "instance-type" {
  description = "Instance Type"
  type        = string
  default     = "t3.medium"
}

variable "instance-name" {
  description = "Instance Name"
  type        = string
  default     = "ec2-host"
}

variable "key_name" {
  description = "SSH key name for EC2"
  type        = string
  default     = "test"
}

#RDS related properties

variable "storage_type" {
  description = "Storage type like gp2/gp1 ssd etc"
  type        = string
  default     = "gp2"
}
variable "engine" {
  description = "Engine type like postgres, aurora, mysql etc"
  type        = string
  default     = "postgres"
}
variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = "9.6.20"
}
variable "instance_class" {
  description = "Instance class for the DB , please note that bigger size will increase the cost"
  type        = string
  default     = "db.m5.large"
}
variable "name" {
  description = "Name of instance"
  type        = string
  default     = "myApp"
}
variable "username" {
  description = "DB username"
  type        = string
  default     = "postgres"
}

#The RDS secrets values can be retrieved from vault or AWS Service store manager to further enhance the secrets management.
variable "password" {
  description = "DB password"
  type        = string
  sensitive   = true
  default     = "postgresPwd123"
}
variable "port" {
  type        = number
  description = "the default port of postgres"
  default = 5432
}

variable "allocated_storage" {
  description = "Allocated storage in GBs"
  type        = number
  default     = 20
}