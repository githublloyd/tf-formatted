

### VPC ###
resource "aws_vpc" "vpc_base" {
  cidr_block            = "${var.cidr}"
  instance_tenancy      = "${var.instance_tenancy}"
  enable_dns_support    = "${var.dns}"
  enable_dns_hostnames  = "${var.dnsh}"

  tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}



### 3 Tier Subnet Architecture ###
resource "aws_subnet" "red" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
  cidr_block            = "${element(var.red_cidr, count.index)}"
  availability_zone     = "${element(var.az_irl, count.index)}"
  map_public_ip_on_launch = true
    tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}
resource "aws_subnet" "amber" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
  cidr_block            = "${element(var.amber_cidr, count.index)}"
  availability_zone     = "${element(var.az_irl, count.index)}"
    tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}
resource "aws_subnet" "green" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
  cidr_block            = "${element(var.green_cidr, count.index)}"
  availability_zone     = "${element(var.az_irl, count.index)}"
    tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}



### Internet Gateway for VPC ###
resource "aws_internet_gateway" "igw" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
    tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}



### Route Table and Route for Red Subnet ###
resource "aws_route_table" "red_rt" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
    tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}
resource "aws_route" "igw-route" {
  route_table_id        = "${element(aws_route_table.red_rt.*.id, count.index)}"
  destination_cidr_block= "0.0.0.0/0"
  gateway_id            = "${aws_internet_gateway.igw.id}"
  count                 = "${var.az_num}"
}



### Route Table for Amber Subnet ###
resource "aws_route_table" "amber_rt" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
    tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}



### Route Table for Green Subnet ###
resource "aws_route_table" "green_rt" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
    tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}



### Elastic IP ###
resource "aws_eip" "nat" {
 count                 = "${var.az_num}"
 vpc                   = true
}



### NAT Gateway ###
resource "aws_nat_gateway" "nat" {
  count                 = "${var.az_num}"
	allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
	subnet_id = "${element(aws_subnet.red.*.id, count.index)}"
	depends_on = ["aws_internet_gateway.igw"]
    tags = {
    "Name"                = "${var.tagname}"
    "Environment"         = "${var.tagenv}"
  }
}
resource "aws_route" "protected_nat_gateway" {
  count                 = "${var.az_num}"
	route_table_id = "${element(aws_route_table.amber_rt.*.id, count.index)}"
	destination_cidr_block = "${var.nat_dest_cidr}"
	nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"

  timeouts {
    create = "5m"
  }

}



### Route Table Association ###
resource "aws_route_table_association" "red" {
	subnet_id = "${element(aws_subnet.red.*.id, count.index)}"
	route_table_id = "${element(aws_route_table.red_rt.*.id, count.index)}"
  count                 = "${var.az_num}"
}
resource "aws_route_table_association" "amber" {
	subnet_id = "${element(aws_subnet.amber.*.id, count.index)}"
	route_table_id = "${element(aws_route_table.amber_rt.*.id, count.index)}"
  count                 = "${var.az_num}"
}
resource "aws_route_table_association" "green" {
	subnet_id = "${element(aws_subnet.green.*.id, count.index)}"
	route_table_id = "${element(aws_route_table.green_rt.*.id, count.index)}"
  count                 = "${var.az_num}"
}
