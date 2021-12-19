resource "aws_ami_from_instance" "co777-ami-web" {
  name               = "${var.tag_name}-ami-web"
  source_instance_id = aws_instance.co777-weba.id

  depends_on = [
    aws_instance.co777-weba
  ]

  tags = {
    "Name" = "${var.tag_name}_ami_web"
  }
}

resource "aws_ami_from_instance" "co777-ami-was" {
  name               = "${var.tag_name}-ami-was"
  source_instance_id = aws_instance.co777-wasa.id

  depends_on = [
    aws_instance.co777-wasa
  ]

  tags = {
    "Name" = "${var.tag_name}_ami_was"
  }
}


resource "aws_launch_configuration" "co777-aslc-web" {
  name            = "${var.tag_name}-web"
  image_id        = aws_ami_from_instance.co777-ami-web.id
  instance_type   = var.webinst_type
  security_groups = [aws_security_group.co777-sg-Web.id]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "co777-aslc-was" {
  name            = "${var.tag_name}-was"
  image_id        = aws_ami_from_instance.co777-ami-was.id
  instance_type   = var.wasinst_type
  security_groups = [aws_security_group.co777-sg-WAS.id]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "co777-asg-web" {
  name                      = "${var.tag_name}-asg-web"
  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  health_check_grace_period = 10
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.co777-aslc-web.name
  vpc_zone_identifier       = aws_subnet.subnet_web[*].id

  tags = [
    {
      key                 = "Name"
      value               = var.as_inst_web
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_group" "co777-asg-was" {
  name                      = "${var.tag_name}-asg-was"
  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  health_check_grace_period = 10
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.co777-aslc-was.name
  vpc_zone_identifier       = aws_subnet.subnet_was[*].id

  tags = [
    {
      key                 = "Name"
      value               = var.as_inst_was
      propagate_at_launch = true
    }
  ]
}


resource "aws_autoscaling_attachment" "co777-asg-att-web" {
  autoscaling_group_name = aws_autoscaling_group.co777-asg-web.id
  alb_target_group_arn   = aws_lb_target_group.co777-albtg.arn
}

resource "aws_autoscaling_attachment" "co777-asg-att-was" {
  autoscaling_group_name = aws_autoscaling_group.co777-asg-was.id
}
