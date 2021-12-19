resource "aws_security_group" "co777-sg-Bastion" {
  name        = var.sg_Bas_name
  description = var.sg_Bas_name
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.tag_sg_name}_sg_Bastion"
  }
}

resource "aws_security_group_rule" "co777-sg-Bastion-in1" {
  description       = var.sg_Bas_des_inSSH
  type              = var.sg_type_in
  from_port         = var.port_ssh
  to_port           = var.port_ssh
  protocol          = var.sg_protocol_tcp
  cidr_blocks       = [var.sg_cidr_myip] # My IP 변경
  security_group_id = aws_security_group.co777-sg-Bastion.id
}

resource "aws_security_group_rule" "co777-sg-Bastion-in2" {
  description       = var.sg_Bas_des_inICMP
  type              = var.sg_type_in
  from_port         = var.port_all
  to_port           = var.port_all
  protocol          = var.sg_protocol_icmp
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-Bastion.id
}

resource "aws_security_group_rule" "co777-sg-Bastion-out" {
  description       = var.sg_Bas_des_out
  type              = var.sg_type_out
  from_port         = var.port_zero
  to_port           = var.port_zero
  protocol          = var.port_all
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-Bastion.id
}

resource "aws_security_group" "co777-sg-ALB" {
  name        = var.sg_ALB_name
  description = var.sg_ALB_name
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.tag_sg_name}_sg_ALB"
  }
}

resource "aws_security_group_rule" "co777-sg-ALB-in1" {
  description       = var.sg_ALB_des_inHTTP
  type              = var.sg_type_in
  from_port         = var.port_web
  to_port           = var.port_web
  protocol          = var.sg_protocol_tcp
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-ALB.id
}

resource "aws_security_group_rule" "co777-sg-ALB-in2" {
  description       = var.sg_ALB_des_inHTTPS
  type              = var.sg_type_in
  from_port         = var.port_https
  to_port           = var.port_https
  protocol          = var.sg_protocol_tcp
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-ALB.id
}

resource "aws_security_group_rule" "co777-sg-ALB-out" {
  description       = var.sg_ALB_des_out
  type              = var.sg_type_out
  from_port         = var.port_zero
  to_port           = var.port_zero
  protocol          = var.port_all
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-ALB.id
}

resource "aws_security_group" "co777-sg-Web" {
  name        = var.sg_Web_name
  description = var.sg_Web_name
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.tag_sg_name}_sg_Web"
  }
}

resource "aws_security_group_rule" "co777-sg-Web-in1" {
  description              = var.sg_WEB_des_inSSH
  type                     = var.sg_type_in
  from_port                = var.port_ssh
  to_port                  = var.port_ssh
  protocol                 = var.sg_protocol_tcp
  source_security_group_id = aws_security_group.co777-sg-Bastion.id
  security_group_id        = aws_security_group.co777-sg-Web.id
}

resource "aws_security_group_rule" "co777-sg-Web-in2" {
  description              = var.sg_WEB_des_inSSH
  type                     = var.sg_type_in
  from_port                = var.port_ssh
  to_port                  = var.port_ssh
  protocol                 = var.sg_protocol_tcp
  source_security_group_id = aws_security_group.co777-sg-Cont.id
  security_group_id        = aws_security_group.co777-sg-Web.id
}

resource "aws_security_group_rule" "co777-sg-Web-in3" {
  description              = var.sg_WEB_des_inHTTP
  type                     = var.sg_type_in
  from_port                = var.port_web
  to_port                  = var.port_web
  protocol                 = var.sg_protocol_tcp
  source_security_group_id = aws_security_group.co777-sg-ALB.id
  security_group_id        = aws_security_group.co777-sg-Web.id
}

resource "aws_security_group_rule" "co777-sg-Web-in4" {
  description       = var.sg_WEB_des_inICMP
  type              = var.sg_type_in
  from_port         = var.port_all
  to_port           = var.port_all
  protocol          = var.sg_protocol_icmp
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-Web.id
}

resource "aws_security_group_rule" "co777-sg-Web-out" {
  description       = var.sg_WEB_des_out
  type              = var.sg_type_out
  from_port         = var.port_zero
  to_port           = var.port_zero
  protocol          = var.port_all
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-Web.id
}

resource "aws_security_group" "co777-sg-WAS" {
  name        = var.sg_WAS_name
  description = var.sg_WAS_name
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.tag_sg_name}_sg_WAS"
  }
}

resource "aws_security_group_rule" "co777-sg-WAS-in1" {
  description              = var.sg_WAS_des_inSSH
  type                     = var.sg_type_in
  from_port                = var.port_ssh
  to_port                  = var.port_ssh
  protocol                 = var.sg_protocol_tcp
  source_security_group_id = aws_security_group.co777-sg-Bastion.id
  security_group_id        = aws_security_group.co777-sg-WAS.id
}

resource "aws_security_group_rule" "co777-sg-WAS-in2" {
  description              = var.sg_WAS_des_inSSH
  type                     = var.sg_type_in
  from_port                = var.port_ssh
  to_port                  = var.port_ssh
  protocol                 = var.sg_protocol_tcp
  source_security_group_id = aws_security_group.co777-sg-Cont.id
  security_group_id        = aws_security_group.co777-sg-WAS.id
}

resource "aws_security_group_rule" "co777-sg-WAS-in3" {
  description       = var.sg_WAS_des_inHTTP
  type              = var.sg_type_in
  from_port         = var.port_was
  to_port           = var.port_was
  protocol          = var.sg_protocol_tcp
  cidr_blocks       = [var.sg_cidr_was[0]]
  security_group_id = aws_security_group.co777-sg-WAS.id
}

resource "aws_security_group_rule" "co777-sg-WAS-in4" {
  description       = var.sg_WAS_des_inHTTP
  type              = var.sg_type_in
  from_port         = var.port_was
  to_port           = var.port_was
  protocol          = var.sg_protocol_tcp
  cidr_blocks       = [var.sg_cidr_was[1]]
  security_group_id = aws_security_group.co777-sg-WAS.id
}

resource "aws_security_group_rule" "co777-sg-WAS-in5" {
  description       = var.sg_WAS_des_inICMP
  type              = var.sg_type_in
  from_port         = var.port_all
  to_port           = var.port_all
  protocol          = var.sg_protocol_icmp
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-WAS.id
}

#in6는 web ec2에서 들어오는 traffic 허용
resource "aws_security_group_rule" "co777-sg-WAS-in6" {
  description              = var.sg_WAS_des_inTRA
  type                     = var.sg_type_in
  from_port                = var.port_zero
  to_port                  = var.port_zero
  protocol                 = var.port_all
  source_security_group_id = aws_security_group.co777-sg-Web.id
  security_group_id        = aws_security_group.co777-sg-WAS.id
}

resource "aws_security_group_rule" "co777-sg-WAS-out" {
  description       = var.sg_WAS_des_out
  type              = var.sg_type_out
  from_port         = var.port_zero
  to_port           = var.port_zero
  protocol          = var.port_all
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-WAS.id
}

resource "aws_security_group" "co777-sg-Cont" {
  name        = var.sg_Cont_name
  description = var.sg_Cont_name
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.tag_sg_name}_sg_Cont"
  }
}

resource "aws_security_group_rule" "co777-sg-Cont-in1" {
  description              = var.sg_Cont_des_inSSH
  type                     = var.sg_type_in
  from_port                = var.port_ssh
  to_port                  = var.port_ssh
  protocol                 = var.sg_protocol_tcp
  source_security_group_id = aws_security_group.co777-sg-Bastion.id
  security_group_id        = aws_security_group.co777-sg-Cont.id
}

resource "aws_security_group_rule" "co777-sg-Cont-in2" {
  description       = var.sg_Cont_des_inICMP
  type              = var.sg_type_in
  from_port         = var.port_all
  to_port           = var.port_all
  protocol          = var.sg_protocol_icmp
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-Cont.id
}

resource "aws_security_group_rule" "co777-sg-Cont-out" {
  description       = var.sg_Cont_des_out
  type              = var.sg_type_out
  from_port         = var.port_zero
  to_port           = var.port_zero
  protocol          = var.port_all
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-Cont.id
}

resource "aws_security_group" "co777-sg-Mysql" {
  name        = var.sg_Mysql_name
  description = var.sg_Mysql_name
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.tag_sg_name}_sg_Mysql"
  }
}

resource "aws_security_group_rule" "co777-sg-Mysql-in" {
  description              = var.sg_Mysql_des_inMYSQL
  type                     = var.sg_type_in
  from_port                = var.port_mysql
  to_port                  = var.port_mysql
  protocol                 = var.sg_protocol_tcp
  source_security_group_id = aws_security_group.co777-sg-WAS.id
  security_group_id        = aws_security_group.co777-sg-Mysql.id
}

resource "aws_security_group_rule" "co777-sg-Mysql-out" {
  description       = var.sg_Mysql_des_out
  type              = var.sg_type_out
  from_port         = var.port_zero
  to_port           = var.port_zero
  protocol          = var.port_all
  cidr_blocks       = [var.sg_cidr_all]
  security_group_id = aws_security_group.co777-sg-Mysql.id
}

#Bastion
resource "aws_instance" "co777-bastion" {
  ami                         = var.ami_aml
  instance_type               = var.web_ec2_type
  key_name                    = var.key_name
  availability_zone           = var.ava_zonea
  associate_public_ip_address = true
  subnet_id                   = var.subnet_pub[0]
  vpc_security_group_ids      = [aws_security_group.co777-sg-Bastion.id]

  tags = {
    Name = "${var.tag_ec2_name}_Bastion"
  }
}

#WEB1
resource "aws_instance" "co777-weba" {
  ami                    = var.ami_aml
  instance_type          = var.web_ec2_type
  key_name               = var.key_name
  availability_zone      = var.ava_zonea
  subnet_id              = var.subnet_web[0]
  vpc_security_group_ids = [aws_security_group.co777-sg-Web.id]

  tags = {
    Name = "${var.tag_ec2_name}_Weba"
    role = var.ans_web
  }
}

#WEB2
resource "aws_instance" "co777-webc" {
  ami                    = var.ami_aml
  instance_type          = var.web_ec2_type
  key_name               = var.key_name
  availability_zone      = var.ava_zonec
  subnet_id              = var.subnet_web[1]
  vpc_security_group_ids = [aws_security_group.co777-sg-Web.id]

  tags = {
    Name = "${var.tag_ec2_name}_Webc"
    role = var.ans_web
  }
}

#WAS1 
resource "aws_instance" "co777-wasa" {
  ami                    = var.ami_ubunt
  instance_type          = var.was_ec2_type
  key_name               = var.key_name
  availability_zone      = var.ava_zonea
  subnet_id              = var.subnet_was[0]
  vpc_security_group_ids = [aws_security_group.co777-sg-WAS.id]

  tags = {
    Name = "${var.tag_ec2_name}_WASa"
    role = var.ans_was
  }
}

#WAS2
resource "aws_instance" "co777-wasc" {
  ami                    = var.ami_ubunt
  instance_type          = var.was_ec2_type
  key_name               = var.key_name
  availability_zone      = var.ava_zonec
  subnet_id              = var.subnet_was[1]
  vpc_security_group_ids = [aws_security_group.co777-sg-WAS.id]

  tags = {
    Name = "${var.tag_ec2_name}_WASc"
    role = var.ans_was
  }
}

resource "aws_instance" "co777-cont" {
  ami                    = var.ami_ubunt
  instance_type          = var.was_ec2_type
  key_name               = var.key_name
  availability_zone      = var.ava_zonea
  subnet_id              = var.subnet_cont
  vpc_security_group_ids = [aws_security_group.co777-sg-Cont.id]

  tags = {
    Name = "${var.tag_ec2_name}_Cont"
    role = var.ans_cont
  }
}
