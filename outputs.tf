output "vpc_id" {
  value = aws_vpc.cis4850_vpc.id
}

output "subnet_public_id" {
  value = aws_subnet.cis4850_public_subnet.id
}

output "subnet_private_id" {
  value = aws_subnet.cis4850_private_subnet.id
}


output "instances" {
  value = aws_instance.minecraft.id
}



