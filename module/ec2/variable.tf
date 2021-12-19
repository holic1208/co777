variable "tag_sg_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "sg_cidr_myip" {
  type = string
}

variable "sg_cidr_all" {
  type = string
}

variable "sg_cidr_was" {
  type = list(string)
}

variable "port_zero" {
  type    = number
  default = 0
}

variable "port_all" {
  type    = number
  default = -1
}

variable "port_ssh" {
  type    = number
  default = 22
}

variable "port_web" {
  type = number
}

variable "port_https" {
  type = number
}

variable "port_mysql" {
  type = number
}

variable "port_was" {
  type = number
}

variable "sg_type_in" {
  type    = string
  default = "ingress"
}

variable "sg_type_out" {
  type    = string
  default = "egress"
}

variable "sg_protocol_tcp" {
  type    = string
  default = "tcp"
}

variable "sg_protocol_icmp" {
  type    = string
  default = "icmp"
}

variable "sg_Bas_name" {
  type = string
}

variable "sg_Bas_des_inSSH" {
  type = string
}

variable "sg_Bas_des_inICMP" {
  type = string
}

variable "sg_Bas_des_out" {
  type = string
}

variable "sg_ALB_name" {
  type = string
}

variable "sg_ALB_des_inHTTP" {
  type = string
}

variable "sg_ALB_des_inHTTPS" {
  type = string
}

variable "sg_ALB_des_out" {
  type = string
}

variable "sg_Web_name" {
  type = string
}

variable "sg_WEB_des_inSSH" {
  type = string
}

variable "sg_WEB_des_inHTTP" {
  type = string
}

variable "sg_WEB_des_inICMP" {
  type = string
}

variable "sg_WEB_des_out" {
  type = string
}

variable "sg_WAS_name" {
  type = string
}

variable "sg_WAS_des_inSSH" {
  type = string
}

variable "sg_WAS_des_inHTTP" {
  type = string
}

variable "sg_WAS_des_inICMP" {
  type = string
}

variable "sg_WAS_des_inTRA" {
  type = string
}

variable "sg_WAS_des_out" {
  type = string
}

variable "sg_Cont_name" {
  type = string
}

variable "sg_Cont_des_inSSH" {
  type = string
}

variable "sg_Cont_des_inICMP" {
  type = string
}

variable "sg_Cont_des_out" {
  type = string
}

variable "sg_Mysql_name" {
  type = string
}

variable "sg_Mysql_des_inMYSQL" {
  type = string
}

variable "sg_Mysql_des_out" {
  type = string
}

########

variable "tag_ec2_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "ami_aml" {
  type = string
}

variable "ami_ubunt" {
  type = string
}

variable "web_ec2_type" {
  type = string
}

variable "was_ec2_type" {
  type = string
}

variable "ava_zonea" {
  type = string
}

variable "ava_zonec" {
  type = string
}

variable "subnet_pub" {
  type = list(string)
}

variable "subnet_web" {
  type = list(string)
}

variable "subnet_was" {
  type = list(string)
}

variable "subnet_cont" {
  type = string
  # 
}

variable "ans_web" {
  type = string
}

variable "ans_was" {
  type = string
}

variable "ans_cont" {
  type = string
}
