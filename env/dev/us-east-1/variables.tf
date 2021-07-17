variable "region" {
  description = "The region of the AWS service."
  type        = string
  default = "us-east-1"
}

variable "profile" {
  description = "The profile name configured in aws credentials file using aws cli"
  type        = string
  default = "dev-profile-terraform"
}

variable "ami" {
  description = "AMI ID used for all EC2"
  type = string
  default = "ami-0c1a7f89451184c8b"
}

variable "key_name" {
  description = "SSH key name for EC2"
  type = string
  default = "dev-"
}