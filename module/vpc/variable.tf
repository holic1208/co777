variable "tag_name" {
  type = string
}

variable "region" {
  type = string
}

variable "ava_zone" {
  type = list(string)
}

variable "cidr_route" {
  type = string
}

variable "cidr_main" {
  type = string
}

variable "cidr_public" {
  type = list(string)
}

variable "cidr_private_web" {
  type = list(string)
}

variable "cidr_private_was" {
  type = list(string)
}

variable "cidr_private_db" {
  type = list(string)
}

variable "cidr_private_cont" {
  type = string
}
