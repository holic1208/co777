output "vpc_id" {
  value = aws_vpc.co777-vpc.id
}

output "subnet_pub" {
  value = aws_subnet.subnet_pub[*].id
}

output "subnet_web" {
  value = aws_subnet.subnet_web[*].id
}

output "subnet_was" {
  value = aws_subnet.subnet_was[*].id
}

output "subnet_mysql" {
  value = aws_subnet.subnet_db[*].id
}

output "subnet_cont" {
  value = aws_subnet.subnet_cont.id
}
