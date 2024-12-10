
# AWS configuration
provider "aws" {
  region = "${var.region}"
}

##########
# VPC
##########


# VPC
resource "aws_vpc" "cis4850_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "cis4850_vpc"
  }
}

#Subnet
resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidr)
  vpc_id = aws_vpc.cis4850_vpc.id
  cidr_block = var.subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true  // Enables automatic IP allocation for the subnet. This makes the subnet PUBLIC
  
  tags = {
    Name = var.subnet_names[count.index]
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cis4850_vpc.id

  tags = {
    Name = "MyInternetGateway"
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
  count = length(var.subnet_cidr)
  // Associates both the subnets to the given route table [Explicit Association]
  subnet_id = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rt.id
}



##########
# SG
##########

resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow HTTP, SSH inbound traffic"
  vpc_id      = aws_vpc.cis4850_vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
  description      = "HTTPS"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CIS4850-SecurityGroup"
  }
}


##########
# EC2
##########

resource "aws_instance" "web" {
  count = length(aws_subnet.subnets.id)
  ami = "ami-0005e0cfe09cc9050"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.subnets.id[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = var.instanceNames[count.index]
  }
}



##########
# ALB
##########

resource "aws_lb" "alb" {
  name = "Application-Load-Balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg.id]
  subnets = aws_subnet.subnets.id
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name = "tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.cis4850_vpc.id
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "tga" {
  count = length(aws_instance.web.instances)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.web.instances[count.index]
  port = 80
}