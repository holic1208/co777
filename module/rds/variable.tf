variable "db_sub_name" {
  type = string
}

variable "subnet_mysql" {
  type = list(string)
}

variable "tag_name" {
  type    = string
  default = "co777"
}

variable "storage_size" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "rds_engine" {
  type = string
}

variable "rds_version" {
  type = string
}

variable "db_class" {
  type = string
}

variable "username" {
  type = string
}

variable "identifier" {
  type = string
}

variable "password" {
  type = string
}

variable "security_Mysql_id" {
  type = string
}
variable "db_name" {
  type = string
}
