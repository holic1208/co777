variable "tag_as_name" {
  type = string
}

# variable "instance_weba_id" {
#   type = string
# }

# variable "instance_wasa_id" {
#   type = string
# }

variable "security_Web_id" {
  type = string
}

variable "security_WAS_id" {
  type = string
}

variable "subnet_web" {
  type = list(string)
}

variable "subnet_was" {
  type = list(string)
}

variable "as_web_target" {
  type = string
}

variable "key_name" {
  type = string
  #
}

variable "as_web_name" {
  type = string
}

variable "as_was_name" {
  type = string
}

variable "web_ec2_type" {
  type = string
}

variable "was_ec2_type" {
  type = string
}

variable "as_min_size" {
  type = number
}

variable "as_max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "health_type" {
  type = string
}
