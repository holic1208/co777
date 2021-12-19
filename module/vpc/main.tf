resource "aws_vpc" "co777-vpc" {
  cidr_block = var.cidr_main

  tags = {
    Name = "${var.tag_name}_vpc"
  }
}

# pub subnet
resource "aws_subnet" "subnet_pub" {
  vpc_id            = aws_vpc.co777-vpc.id
  count             = length(var.cidr_public)
  cidr_block        = var.cidr_public[count.index]
  availability_zone = "${var.region}${var.ava_zone[count.index]}"

  tags = {
    Name = "${var.tag_name}_pub${var.ava_zone[count.index]}"
  }
}

# web subnet 
resource "aws_subnet" "subnet_web" {
  vpc_id            = aws_vpc.co777-vpc.id
  count             = length(var.cidr_private_web)
  cidr_block        = var.cidr_private_web[count.index]
  availability_zone = "${var.region}${var.ava_zone[count.index]}"

  tags = {
    Name = "${var.tag_name}_web${var.ava_zone[count.index]}"
  }
}

# was subnet 
resource "aws_subnet" "subnet_was" {
  vpc_id            = aws_vpc.co777-vpc.id
  count             = length(var.cidr_private_was)
  cidr_block        = var.cidr_private_was[count.index]
  availability_zone = "${var.region}${var.ava_zone[count.index]}"

  tags = {
    Name = "${var.tag_name}_was${var.ava_zone[count.index]}"
  }
}

# cont subnet
resource "aws_subnet" "subnet_cont" {
  vpc_id            = aws_vpc.co777-vpc.id
  cidr_block        = var.cidr_private_cont
  availability_zone = "${var.region}${var.ava_zone[0]}"
}

# db subnet 
resource "aws_subnet" "subnet_db" {
  vpc_id            = aws_vpc.co777-vpc.id
  count             = length(var.cidr_private_db)
  cidr_block        = var.cidr_private_db[count.index]
  availability_zone = "${var.region}${var.ava_zone[count.index]}"

  tags = {
    Name = "${var.tag_name}_db${var.ava_zone[count.index]}"
  }
}

resource "aws_internet_gateway" "co777-igw" {
  vpc_id = aws_vpc.co777-vpc.id

  tags = {
    Nmae = "${var.tag_name}_igw"
  }
}

resource "aws_route_table" "co777-igwrt" {
  vpc_id = aws_vpc.co777-vpc.id

  route {
    cidr_block = var.cidr_route
    gateway_id = aws_internet_gateway.co777-igw.id
  }

  tags = {
    Name = "${var.tag_name}_igwroute"
  }
}

#igw association

resource "aws_route_table_association" "co777-igwrtass-pub" {
  count          = length(var.cidr_public)
  subnet_id      = aws_subnet.subnet_pub[count.index].id
  route_table_id = aws_route_table.co777-igwrt.id
}

resource "aws_eip" "co777-nat-eip" {
  vpc = true

  tags = {
    Name = "${var.tag_name}_nat"
  }
}

resource "aws_nat_gateway" "co777-natgw" {
  allocation_id = aws_eip.co777-nat-eip.id
  subnet_id     = aws_subnet.subnet_pub[0].id
  depends_on = [
    aws_internet_gateway.co777-igw
  ]

  tags = {
    Name = "${var.tag_name}_natgw"
  }
}

resource "aws_route_table" "co777-natgwrt" {
  vpc_id = aws_vpc.co777-vpc.id

  route {
    cidr_block = var.cidr_route
    gateway_id = aws_nat_gateway.co777-natgw.id
  }

  tags = {
    Name = "${var.tag_name}_natgw"
  }
}

#igw association web
resource "aws_route_table_association" "co777-natgwrtass-web" {
  count          = length(var.cidr_private_web)
  subnet_id      = aws_subnet.subnet_web[count.index].id
  route_table_id = aws_route_table.co777-natgwrt.id
}

#igw association was
resource "aws_route_table_association" "co777-natgwrtass-was" {
  count          = length(var.cidr_private_was)
  subnet_id      = aws_subnet.subnet_was[count.index].id
  route_table_id = aws_route_table.co777-natgwrt.id
}

resource "aws_route_table_association" "co777-natgwrtass-db" {
  count          = length(var.cidr_private_db)
  subnet_id      = aws_subnet.subnet_db[count.index].id
  route_table_id = aws_route_table.co777-natgwrt.id
}

resource "aws_route_table_association" "co777-natgwrtass-con" {
  subnet_id      = aws_subnet.subnet_cont.id
  route_table_id = aws_route_table.co777-natgwrt.id
}
