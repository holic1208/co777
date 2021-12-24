data "aws_acm_certificate" "co777" {
  domain   = "*.suuu.pw"
  statuses = ["ISSUED"]
}

resource "aws_lb" "co777-alb" {
  name               = "${var.tag_name}-alb"
  internal           = false
  load_balancer_type = var.alb_type
  security_groups    = [var.security_ALB_id]
  subnets            = [var.subnet_pub[0], var.subnet_pub[1]]
  tags = {
    Name = "${var.tag_name}_alb"
  }
}

resource "aws_lb_target_group" "co777-albtg" {
  name     = "${var.tag_name}-albtg"
  port     = var.port_web
  protocol = var.protocol_http
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.healthy_threshold
    interval            = var.interval
    matcher             = var.matcher
    path                = var.health_path
    port                = var.port_traffic
    protocol            = var.protocol_http
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    Name = "${var.tag_name}_albtg"
  }
}

resource "aws_lb_listener" "co777-alblis-re" {
  load_balancer_arn = aws_lb.co777-alb.arn
  port              = var.port_web
  protocol          = var.protocol_http

  default_action {
    type = var.lis_action_re
    redirect {
      port        = var.port_https
      protocol    = var.protocol_https
      status_code = var.status_code
    }
  }
}

resource "aws_lb_listener" "co777-alblis-fo" {
  load_balancer_arn = aws_lb.co777-alb.arn
  port              = var.port_https
  protocol          = var.protocol_https
  certificate_arn   = data.aws_acm_certificate.co777.arn
  default_action {
    type             = var.lis_action_fo
    target_group_arn = aws_lb_target_group.co777-albtg.arn
  }
}

resource "aws_lb_target_group_attachment" "co777-albtg-att1" {
  target_group_arn = aws_lb_target_group.co777-albtg.arn
  target_id        = var.instance_weba_id
  port             = var.port_web
}

resource "aws_lb_target_group_attachment" "co777-albtg-att2" {
  target_group_arn = aws_lb_target_group.co777-albtg.arn
  target_id        = var.instance_webc_id
  port             = var.port_web
}

resource "aws_lb" "co777-nlb" {
  name               = "${var.tag_name}-nlb"
  internal           = true
  load_balancer_type = var.nlb_type
  subnets            = [var.subnet_web[0], var.subnet_web[1]]

  tags = {
    Name = "${var.tag_name}_nlb"
  }
}

resource "aws_lb_target_group" "co777-nlbtg" {
  name        = "${var.tag_name}-nlbtg"
  port        = var.port_was
  protocol    = var.protocol_tcp
  target_type = var.nlb_target_type
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.tag_name}_nlbtg"
  }
}

resource "aws_lb_listener" "co777-nlbli" {
  load_balancer_arn = aws_lb.co777-nlb.arn
  port              = var.port_was
  protocol          = var.protocol_tcp

  default_action {
    type             = var.lis_action_fo
    target_group_arn = aws_lb_target_group.co777-nlbtg.arn
  }
}

resource "aws_lb_target_group_attachment" "co777-nlbtg-att1" {
  target_group_arn = aws_lb_target_group.co777-nlbtg.arn
  target_id        = var.instance_wasa_ip
  port             = var.port_was
}

resource "aws_lb_target_group_attachment" "co777-nlbtg-att2" {
  target_group_arn = aws_lb_target_group.co777-nlbtg.arn
  target_id        = var.instance_wasb_ip
  port             = var.port_was
}
