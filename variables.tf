
##########
# Region
##########

variable "region" {
  type        = string
  default     = "us-west-1"
  description = "AWS region to deploy to"
}

variable "availability_zone" {
  description = "Subnets Availability Zone"
  default = "us-west-1a"
}


##########
# VPC
##########

variable "vpc_cidr" {
  default     = "10.48.0.0/16"
  description = "CIDR block for the VPC"
}

variable "subnet_public_cidr" {
  default = "10.48.50.0/24"
  description = "CIDR block for the public subnet"
}


variable "subnet_private_cidr" {
  default = "10.48.100.0/24"
  description = "CIDR block for the private subnet"

}


######
# Minecraft EC2
######
variable "ec2_instance_connect" {
  type        = bool
  default     = false
  description = "Keep SSH (port 22) open to allow connections via EC2 Instance Connect."
}

variable "minecraft_ami" {
  description = "The Minecraft AMIs to use for the host"
  # Default is Amazon Linux 2023 AMI
  default = "ami-038bba9a164eb3dc1"
}

variable "download_url" {
  type        = string
  default     = "https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar"
  description = "Minecraft server download URL"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The EC2 instance type of the server."
}


variable "static_ip" {
  type        = bool
  default     = false
  description = "Should the instance retain its IPv4 address after being stopped? Charges apply while the server is stopped."
}