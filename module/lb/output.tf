output "as_web_target" {
  value = aws_lb_target_group.co777-albtg.arn
}

output "as_was_target" {
  value = aws_lb_target_group.co777-nlbtg.arn
}