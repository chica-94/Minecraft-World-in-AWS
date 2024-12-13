
# AWS configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.33"
    }
  }
}

provider "aws" {
  region = var.region
}

##########
# VPC
##########


# VPC
resource "aws_vpc" "cis4850_vpc" {

  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags = {
    Name = "cis4850-vpc"
  }
}

#Subnet
resource "aws_subnet" "cis4850_public_subnet" {

  vpc_id = aws_vpc.cis4850_vpc.id
  cidr_block = var.subnet_public_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true  // Enables automatic IP allocation for the subnet. This makes the subnet PUBLIC
  
  tags = {
    Name = "cis4850-PublicSubnet"
  }
}

resource "aws_subnet" "cis4850_private_subnet" {

  vpc_id = aws_vpc.cis4850_vpc.id
  cidr_block = var.subnet_private_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "cis4850-PrivateSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cis4850_vpc.id

  tags = {
    Name = "CIS4850-InternetGateway"
  }
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.cis4850_vpc.id

  # This configuration routes all the packets that has destination address outside the VPC to the internet gateway
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "MAIN"
  }
}


# Route Table Associations
resource "aws_route_table_association" "rta" {

  // Associates both the subnets to the given route table [Explicit Association]
  subnet_id = aws_subnet.cis4850_public_subnet.id
  route_table_id = aws_route_table.rt.id
}



##########
# SG
##########


resource "aws_security_group" "minecraft" {
  name        = "cis4850-minecraft-sg"
  vpc_id      = aws_vpc.cis4850_vpc.id
  description = "Minecraft server traffic"

  # Allow Minecraft Connections anywhere
  ingress {
  from_port         = 25565
  to_port           = 25565
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

  }

  # SSH Protocol
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]

  }


  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "all"
    cidr_blocks       = ["0.0.0.0/0"]
  }

    tags = {
    Name = "CIS4850-SecurityGroup"
  }

}


##########
# EC2
##########

resource "aws_instance" "minecraft" {
  ami                         = var.minecraft_ami
  subnet_id                   = aws_subnet.cis4850_public_subnet.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.minecraft.id]
  associate_public_ip_address = true

  tags = {
    Name = "CIS4850-Minecraft"
  }

  user_data = file("startup.sh")
}


