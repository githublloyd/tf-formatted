

### Common tags for all network resources ###

locals {
  common_tags = {
    Component = "${var.tagmod}"
    Environment = "${var.tagenv}"
  }
}


### VPC ###
resource "aws_vpc" "vpc_base" {
  cidr_block            = "${var.cidr}"
  instance_tenancy      = "${var.instance_tenancy}"
  enable_dns_support    = "${var.dns}"
  enable_dns_hostnames  = "${var.dnsh}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${var.tagenv}-tf-vpc"
      )
    )}"
  }



### 3 Tier Subnet Architecture ###
resource "aws_subnet" "red" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
  cidr_block            = "${element(var.red_cidr, count.index)}"
  availability_zone     = "${element(var.az_irl, count.index)}"
  map_public_ip_on_launch = true
   tags = "${merge(
     local.common_tags,
     map(
     "Name", "red-subnet-${element(var.az_irl, count.index)}"))}"
  }



resource "aws_subnet" "amber" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
  cidr_block            = "${element(var.amber_cidr, count.index)}"
  availability_zone     = "${element(var.az_irl, count.index)}"
    tags = "${merge(
     local.common_tags,
     map(
     "Name", "amber-subnet-${element(var.az_irl, count.index)}"))}"
  }
resource "aws_subnet" "green" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
  cidr_block            = "${element(var.green_cidr, count.index)}"
  availability_zone     = "${element(var.az_irl, count.index)}"
    tags = "${merge(
     local.common_tags,
     map(
     "Name", "green-subnet-${element(var.az_irl, count.index)}"))}"
  }



### Internet Gateway for VPC ###
resource "aws_internet_gateway" "igw" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
    tags = "${merge(
      local.common_tags,
      map(
        "Name", "${var.tagenv}-tf-igw"
      )
    )}"
  }
}



### Route Table and Route for Red Subnet ###
resource "aws_route_table" "red_rt" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
    tags = "${merge(
      local.common_tags,
      map(
        "Name", "${var.tagenv}-tf-red_rt"
      )
    )}"
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
    tags = "${merge(
      local.common_tags,
      map(
        "Name", "${var.tagenv}-tf-amber_rt"
      )
    )}"
  }
}



### Route Table for Green Subnet ###
resource "aws_route_table" "green_rt" {
  vpc_id                = "${aws_vpc.vpc_base.id}"
  count                 = "${var.az_num}"
    tags = "${merge(
      local.common_tags,
      map(
        "Name", "${var.tagenv}-tf-green_rt"
      )
    )}"
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
    tags = "${merge(
      local.common_tags,
      map(
        "Name", "${var.tagenv}-tf-nat_gw"
      )
    )}"
  }
}
resource "aws_route" "protected_nat_gateway" {
  count                 = "${var.az_num}"
	route_table_id = "${element(aws_route_table.amber_rt.*.id, count.index)}"
	destination_cidr_block = "${var.nat_dest_cidr}"
	nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
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
