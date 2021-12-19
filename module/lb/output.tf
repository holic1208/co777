output "alb-dns" {
  value = "aws_lb.${var.tag_name}-alb.dns_name"
}

output "nlb-dns" {
  value = "aws_lb.${var.tag_name}-nlb.dns_name"
}
