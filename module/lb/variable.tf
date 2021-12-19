variable "tag_name" {
  type = string
}

variable "alb_type" {
  type = string
}

variable "security_ALB_id" {
  type = string
}

variable "subnet_pub" {
  type = list(string)
}

variable "subnet_web" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "healthy_threshold" {
  type = string
}

variable "interval" {
  type = string
}

variable "matcher" {
  type = string
}

variable "health_path" {
  type = string
}

variable "port_traffic" {
  type = string
}

variable "protocol_http" {
  type = string
}

variable "timeout" {
  type = string
}

variable "unhealthy_threshold" {
  type = string
}

variable "port_web" {
  type = number
}

variable "port_was" {
  type = number
}

variable "lis_action" {
  type = string
}

variable "instance_weba_id" {
  type = string
}

variable "instance_webc_id" {
  type = string
}

variable "nlb_type" {
  type = string
}

variable "nlb_target_type" {
  type = string
}

variable "protocol_tcp" {
  type = string
}

variable "instance_wasa_ip" {
  type = string
}

variable "instance_wasb_ip" {
  type = string
}

