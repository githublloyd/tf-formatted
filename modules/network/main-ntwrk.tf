

### VPC ###
resource "aws_vpc" "vpc_base" {
  cidr_block            = "${var.cidr}"
  instance_tenancy      = "${var.instance_tenancy}"
  enable_dns_support    = "${var.dns}"
  enable_dns_hostnames  = "${var.dnsh}"
}



### 3 Tier Subnet Architecture ###
resource "aws_subnet" "red" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${length(var.az_num)}"
  cidr_block            = "${var.red_cidr[count.index]}"
  availability_zone     = "${element(var.az_irl, count.index)}"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "amber" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${length(var.az_num)}"
  cidr_block            = "${var.amber_cidr[count.index]}"
  availability_zone     = "${element(var.az_irl, count.index)}"
}
resource "aws_subnet" "green" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${length(var.az_num)}"
  cidr_block            = "${var.green_cidr[count.index]}"
  availability_zone     = "${element(var.az_irl, count.index)}"
}



### Internet Gateway for VPC ###
resource "aws_internet_gateway" "igw" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
}



### Route Table and Route for Red Subnet ###
resource "aws_route_table" "red_rt" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
}
resource "aws_route" "igw-route" {
  route_table_id        = "${aws_route_table.red_rt.id}"
  destination_cidr_block= "0.0.0.0/0"
  gateway_id            = "${aws_internet_gateway.igw.id}"
}



### Route Table for Amber Subnet ###
resource "aws_route_table" "amber_rt" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
}



### Route Table for Green Subnet ###
resource "aws_route_table" "green_rt" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
}



### Elastic IP ###
resource "aws_eip" "nat" {
 count                 = 1
 vpc                   = "${aws_vpc.vpc_base.id}"
}



### NAT Gateway ###
resource "aws_nat_gateway" "nat" {
	allocation_id = "${aws_eip.nat.id}"
	subnet_id = "${aws_subnet.red.id}"
	depends_on = ["aws_internet_gateway.igw"]
}
resource "aws_route" "protected_nat_gateway" {
	route_table_id = "${aws_route_table.red_rt.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat.id}"
}



### Route Table Association ###
resource "aws_route_table_association" "red" {
	subnet_id = "${aws_subnet.green.id}"
	route_table_id = "${aws_route_table.red_rt.id}"
}
resource "aws_route_table_association" "amber" {
	subnet_id = "${aws_subnet.amber.id}"
	route_table_id = "${aws_route_table.amber_rt.id}"
}
resource "aws_route_table_association" "green" {
	subnet_id = "${aws_subnet.green.id}"
	route_table_id = "${aws_route_table.green_rt.id}"
}
