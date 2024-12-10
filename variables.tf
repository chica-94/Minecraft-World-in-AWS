##########
# VPC
##########

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnets"
  type = list(string)
}

variable "subnet_names"{
    description = "Names for the subnets"
    type = list(string)
    default = ["PublicSubnet1", "PublicSubnet2"]
}

##########
# SG
##########

variable "vpc_id" {
  description = "VPC Id for Security Group"
  type = string
}



##########
# EC2
##########

variable "sg_id" {
  description = "Security Group Id for the EC2 instance"
  type = string
}

variable "subnets_id" {
  description = "Subnets Id for EC2 instance"
  type = list(string)
}

variable "instanceNames"{
    description = "Names for the EC2 instances"
    type = list(string)
}

##########
# ALB
##########

variable "sg_id" {
  description = "Security Group Id for Application Load Balancers"
  type = string
}

variable "subnets" {
  description = "Subnet Id for Application Load Balancers"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC Id for Application Load Balancers"
  type = string
}

variable "ec2_id" {
  description = "EC2 Instance Id for Load Balancers"
  type = list(string)
}


######
# Minecraft
######
variable "ec2_instance_connect" {
  type        = bool
  default     = false
  description = "Keep SSH (port 22) open to allow connections via EC2 Instance Connect."
}

variable "download_url" {
  type        = string
  default     = "https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar"
  description = "Minecraft server download URL"
}

variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "The EC2 instance type of the server. Requires at least t2.medium."
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS region to deploy to"
}

variable "static_ip" {
  type        = bool
  default     = false
  description = "Should the instance retain its IPv4 address after being stopped? Charges apply while the server is stopped."
}