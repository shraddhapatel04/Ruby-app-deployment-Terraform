#####################################################
###########             Locals             ##########
#####################################################
locals {
  no_of_subnets = 3
}

# Declare the data source
data "aws_availability_zones" "azs" {}

#####################################################
###########             VPC                ##########
#####################################################

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"
  tags = {
    Name = "${var.name}"
  }  
}

#####################################################
###########     Subnets     #########
#####################################################

### Private Subnets

resource "aws_subnet" "private_sn" {
  count = "${local.no_of_subnets}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr, 4, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
  tags = {
    Name = "${var.name}-private-sn-${count.index}"
  }
}

resource "aws_subnet" "public_sn" {
  count = "${local.no_of_subnets}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr, 4, 8+ count.index)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
  tags = {
    Name = "${var.name}-public-sn-${count.index}"
  }
}
#####################################################
###########            Internet Gateway     #########
#####################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.name}"
  }
}

#####################################################
###########            NAT Gateway     #########
#####################################################

resource "aws_eip" "nat_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "ngw" {
  count = 1
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public_sn.*.id, count.index)}"

  tags = {
    Name = "${var.name}"
  }
}

#####################################################
###########     Route Tables     #########
#####################################################

## Public Route table 
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${var.name}"
  }
}

## Public route table association rules
resource "aws_route_table_association" "public_route_table_association" {
  count = "${local.no_of_subnets}"
  subnet_id      = "${element(aws_subnet.public_sn.*.id,count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

## Private Route table 
resource "aws_default_route_table" "private_route_table" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags = {
    Name = "${var.name}"
  }
}

## Public route table association rules
resource "aws_route_table_association" "private_route_table_association" {
  count = "${local.no_of_subnets}"
  subnet_id      = "${element(aws_subnet.private_sn.*.id,count.index)}"
  route_table_id = "${aws_default_route_table.private_route_table.id}"
}
