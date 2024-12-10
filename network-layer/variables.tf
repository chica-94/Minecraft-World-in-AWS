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