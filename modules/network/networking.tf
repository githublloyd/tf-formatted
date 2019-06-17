
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
  map_public_ip_on_launch = "${var.pub_ip_on_launch}"
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



### Route Table for Red Subnet ###
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


### Internet Gateway Route ###
resource "aws_route" "igw-route" {
  route_table_id        = "${element(aws_route_table.red_rt.*.id, count.index)}"
  destination_cidr_block= "0.0.0.0/0"
  gateway_id            = "${aws_internet_gateway.igw.id}"
  count                 = "${var.az_num}"
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

resource "aws_route" "protected_nat_gateway" {
  count                 = "${var.az_num}"
	route_table_id = "${element(aws_route_table.amber_rt.*.id, count.index)}"
	destination_cidr_block = "${var.nat_dest_cidr}" ##
	nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}





### Security Group: EC2 Web ###
resource "aws_security_group" "sg-web" {
  vpc_id                = "${aws_vpc.vpc_base.id}"

  ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]	
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["89.101.155.58/32"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

}



### Security Group: ALB ### NOT ATTACHED TO ANY RESOURCE
resource "aws_security_group" "sg-alb" {
  vpc_id                = "${aws_vpc.vpc_base.id}"

  ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]	
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

}


### Appllication Load Balancer: Web ###

resource "aws_lb" "lb-web" {
  
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-alb.id}"]
  subnets            = ["${aws_subnet.red.*.id}"]
  idle_timeout       = 60
  
  enable_deletion_protection = false # Check to false in Console if $ terraform destroy gives out

#  access_logs {
#    bucket  = "${aws_s3_bucket.lloydob-v1bucket.bucket}"
#    prefix  = "lb-web"
#    enabled = true
#  }

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${var.tagenv}-tf-lb-web"
      )
    )}"
}



### Application Load Balancer: Target Group ###

resource "aws_lb_target_group" "lb-tg-web" {

  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc_base.id}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${var.tagenv}-tf-lb-tg-web"
      )
    )}"
}


### Application Load Balancer: Listener ###

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = "${aws_lb.lb-web.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lb-tg-web.arn}"
  }
}