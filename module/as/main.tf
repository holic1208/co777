data "aws_ami" "ami-web" {
  owners = ["self"]

  filter {
    name   = "tag:Name"
    values = ["WEB"]
  }
}

data "aws_ami" "ami-was" {
  owners = ["self"]

  filter {
    name   = "tag:Name"
    values = ["WAS"]
  }
}

resource "aws_launch_configuration" "co777-aslc-web" {
  name            = "${var.tag_as_name}-web"
  image_id        = data.aws_ami.ami-web.id
  instance_type   = var.web_ec2_type
  security_groups = [var.security_Web_id]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "co777-aslc-was" {
  name            = "${var.tag_as_name}-was"
  image_id        = data.aws_ami.ami-was.id
  instance_type   = var.was_ec2_type
  security_groups = [var.security_WAS_id]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "co777-asg-web" {
  name                 = "${var.tag_as_name}-asg-web"
  min_size             = var.as_min_size
  max_size             = var.as_max_size
  desired_capacity     = var.desired_capacity
  health_check_type    = var.health_type
  force_delete         = true
  launch_configuration = aws_launch_configuration.co777-aslc-web.name
  vpc_zone_identifier  = var.subnet_web

  tags = [
    {
      key                 = "Name"
      value               = var.as_web_name
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_group" "co777-asg-was" {
  name                 = "${var.tag_as_name}-asg-was"
  min_size             = var.as_min_size
  max_size             = var.as_max_size
  desired_capacity     = var.desired_capacity
  health_check_type    = var.health_type
  force_delete         = true
  launch_configuration = aws_launch_configuration.co777-aslc-was.name
  vpc_zone_identifier  = var.subnet_was

  tags = [
    {
      key                 = "Name"
      value               = var.as_was_name
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscalingplans_scaling_plan" "co777-plan-web" {
  name = "co777-web-plan"

  application_source {
    tag_filter {
      key    = "Name"
      values = [var.as_web_name]
    }
  }

  scaling_instruction {
    max_capacity       = var.as_max_size
    min_capacity       = var.as_min_size
    resource_id        = format("autoScalingGroup/%s", aws_autoscaling_group.co777-asg-web.name)
    scalable_dimension = "autoscaling:autoScalingGroup:DesiredCapacity"
    service_namespace  = var.plan_namespace

    target_tracking_configuration {
      predefined_scaling_metric_specification {
        predefined_scaling_metric_type = "ASGAverageCPUUtilization"
      }

      target_value = var.plan_value
    }
  }
}

resource "aws_autoscalingplans_scaling_plan" "co777-plan-was" {
  name = "co777-was-plan"

  application_source {
    tag_filter {
      key    = "Name"
      values = [var.as_was_name]
    }
  }

  scaling_instruction {
    max_capacity       = var.as_max_size
    min_capacity       = var.as_min_size
    resource_id        = format("autoScalingGroup/%s", aws_autoscaling_group.co777-asg-was.name)
    scalable_dimension = "autoscaling:autoScalingGroup:DesiredCapacity"
    service_namespace  = var.plan_namespace


    target_tracking_configuration {
      predefined_scaling_metric_specification {
        predefined_scaling_metric_type = "ASGAverageCPUUtilization"
      }

      target_value = var.plan_value
    }
  }
}

resource "aws_autoscaling_attachment" "co777-asg-att-web" {
  autoscaling_group_name = aws_autoscaling_group.co777-asg-web.id
  alb_target_group_arn   = var.as_web_target
}

resource "aws_autoscaling_attachment" "co777-asg-att-was" {
  autoscaling_group_name = aws_autoscaling_group.co777-asg-was.id
  alb_target_group_arn   = var.as_was_target
}
