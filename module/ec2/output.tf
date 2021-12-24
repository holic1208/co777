output "security_ALB_id" {
  value = aws_security_group.co777-sg-ALB.id
}

output "security_Web_id" {
  value = aws_security_group.co777-sg-Web.id
}

output "security_WAS_id" {
  value = aws_security_group.co777-sg-WAS.id
}

output "security_Mysql_id" {
  value = aws_security_group.co777-sg-Mysql.id
}

###########

output "instance_weba_id" {
  value = aws_instance.co777-weba.id
}

output "instance_webc_id" {
  value = aws_instance.co777-webc.id
}

output "instance_wasa_id" {
  value = aws_instance.co777-wasa.id
}

output "instance_wasa_ip" {
  value = aws_instance.co777-wasa.private_ip
}

output "instance_wasc_ip" {
  value = aws_instance.co777-wasc.private_ip
}
