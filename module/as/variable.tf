variable "strategy" {
  type    = string
  default = "cluster"
}

variable "tag_name" {
  type = string
  # default = "co777"
}

variable "as_inst_web" {
  type = string
  # "co777_auto_web"
}

variable "as_inst_was" {
  type = string
  # "co777_auto_WAS"
}

variable "key_name" {
  type = string
  #default = "final-co777"
}

variable "webinst_type" {
  type = string
  #default = "t2.micro"
}

variable "wasinst_type" {
  type = string
  #default = "t2.small"
}
