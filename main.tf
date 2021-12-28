provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "co777-final-pro"
    key    = "final-state/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "co777-final-dynamo"
    encrypt        = true
  }
}




#######################################################
## Keypair                                           ##
#######################################################

module "Key-pair" {
  source = "./module/key"

  key-name   = "final-co777"
  public_key = file("../final-co777.pub")
}




#######################################################
## VPC                                               ##
#######################################################

module "VPC" {
  source = "./module/vpc"

  region            = "ap-northeast-2"
  tag_name          = "co-777"
  ava_zone          = ["a", "c"]
  cidr_route        = "0.0.0.0/0"
  cidr_main         = "10.0.0.0/16"
  cidr_public       = ["10.0.1.0/24", "10.0.5.0/24"]
  cidr_private_web  = ["10.0.2.0/24", "10.0.6.0/24"]
  cidr_private_was  = ["10.0.3.0/24", "10.0.7.0/24"]
  cidr_private_db   = ["10.0.4.0/24", "10.0.8.0/24"]
  cidr_private_cont = "10.0.9.0/24"
}




#######################################################
## Security group & EC2                              ##
#######################################################

module "EC2" {
  source = "./module/ec2"

  ##
  vpc_id = module.VPC.vpc_id
  ##
  tag_sg_name = "co777"
  sg_cidr_all = "0.0.0.0/0"
  port_web    = 80
  port_https  = 443
  port_was    = 8080
  port_mysql  = 3306


  #sg-Bastion
  sg_cidr_myip      = "0.0.0.0/0" # 발표 전에 꼭꼭꼭 수정하기!
  sg_Bas_name       = "Bastion sg rule"
  sg_Bas_des_inSSH  = "Bastion inbound rule-SSH"
  sg_Bas_des_inICMP = "Bastion inbound rule-ICMP"
  sg_Bas_des_out    = "Bastion outbound rule"


  #sg-ALB
  sg_ALB_name        = "ALB sg rule"
  sg_ALB_des_inHTTP  = "ALB inbound rule-HTTP"
  sg_ALB_des_inHTTPS = "ALB inbound rule-HTTPS"
  sg_ALB_des_out     = "ALB outbound rule"


  #sg-Web
  sg_Web_name       = "Web sg rule"
  sg_WEB_des_inSSH  = "Web inbound rule-SSH"
  sg_WEB_des_inHTTP = "Web inbound rule-HTTP"
  sg_WEB_des_inICMP = "Web inbound rule-ICMP"
  sg_WEB_des_out    = "Web outbound rule"


  #sg-WAS
  sg_cidr_was       = ["10.0.2.0/24", "10.0.6.0/24"]
  sg_WAS_name       = "WAS sg rule"
  sg_WAS_des_inSSH  = "Was inbound rule-SSH"
  sg_WAS_des_inHTTP = "Was inbound rule-HTTP"
  sg_WAS_des_inICMP = "Was inbound rule-ICMP"
  sg_WAS_des_inTRA  = "WAS inbound rule-traffic"
  sg_WAS_des_out    = "Was outbound rule"


  #sg-Cont
  sg_Cont_name       = "Cont sg rule"
  sg_Cont_des_inSSH  = "Cont inbound rule-SSH"
  sg_Cont_des_inICMP = "Cont inbound rule-ICMP"
  sg_Cont_des_out    = "Cont outbound rule"


  #sg-Mysql
  sg_Mysql_name        = "Mysql sg rule"
  sg_Mysql_des_inMYSQL = "Mysql inbound rule-Mysql"
  sg_Mysql_des_out     = "Mysql outbound rule"

  #EC2

  ##
  key_name    = module.Key-pair.key_name
  subnet_pub  = module.VPC.subnet_pub
  subnet_web  = module.VPC.subnet_web
  subnet_was  = module.VPC.subnet_was
  subnet_cont = module.VPC.subnet_cont
  ##
  tag_ec2_name = "co777"
  ava_zonea    = "ap-northeast-2a"
  ava_zonec    = "ap-northeast-2c"
  ami_aml      = "ami-003ef1c0e2776ea27"
  ami_ubunt    = "ami-0f8b8babb98cc66d0"
  web_ec2_type = "t2.micro"
  was_ec2_type = "t2.small"
  ans_web      = "nodes_web"
  ans_was      = "nodes_was"
  ans_cont     = "nodes_cont"
}




#######################################################
## load balancer                                     ##
#######################################################

module "LB" {
  source = "./module/lb"

  ##
  vpc_id           = module.VPC.vpc_id
  instance_weba_id = module.EC2.instance_weba_id
  instance_webc_id = module.EC2.instance_webc_id
  security_ALB_id  = module.EC2.security_ALB_id
  subnet_pub       = module.VPC.subnet_pub
  instance_wasa_id = module.EC2.instance_wasa_id
  instance_wasb_id = module.EC2.instance_wasc_id
  subnet_web       = module.VPC.subnet_web
  ##
  tag_name      = "co777"
  port_traffic  = "traffic-port"
  lis_action_fo = "forward"
  lis_action_re = "redirect"
  status_code   = "HTTP_301"


  #alb
  health_path         = "/"
  alb_type            = "application"
  port_web            = 80
  port_https          = 443
  protocol_http       = "HTTP"
  protocol_https      = "HTTPS"
  healthy_threshold   = 3
  interval            = 5
  matcher             = "200"
  timeout             = 2
  unhealthy_threshold = 2


  #nlb
  nlb_type     = "network"
  port_was     = 8080
  protocol_tcp = "TCP"
}




#######################################################
## Auto Scaling                                      ##
#######################################################

module "ASG" {
  source = "./module/as"

  ##
  key_name        = module.Key-pair.key_name
  security_Web_id = module.EC2.security_Web_id
  security_WAS_id = module.EC2.security_WAS_id
  subnet_web      = module.VPC.subnet_web
  subnet_was      = module.VPC.subnet_was
  as_web_target   = module.LB.as_web_target
  as_was_target   = module.LB.as_was_target
  ##
  tag_as_name      = "co777"
  as_web_name      = "co777_auto_web"
  as_was_name      = "co777_auto_was"
  web_ec2_type     = "t2.micro"
  was_ec2_type     = "t2.small"
  as_min_size      = 2
  as_max_size      = 10
  desired_capacity = 2
  health_type      = "EC2"
  plan_namespace   = "autoscaling"
  plan_value       = "60"
}




#######################################################
## RDS                                               ##
#######################################################

module "RDS" {
  source = "./module/rds"

  ##
  subnet_mysql      = module.VPC.subnet_mysql
  security_Mysql_id = module.EC2.security_Mysql_id
  ##
  tag_name     = "co777"
  db_sub_name  = "co777_dbsub"
  storage_size = "20"
  storage_type = "gp2"
  rds_engine   = "mysql"
  rds_version  = "8.0.23"
  db_class     = "db.t3.micro"
  username     = "co777"
  identifier   = "co777mysql"
  password     = "co777!!!"
  db_name      = "petclinic"
}
