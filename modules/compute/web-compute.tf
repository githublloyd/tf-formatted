
### Common tags for all network resources ###

locals {
  common_tags = {
    Component = "${var.tagmod}"
    Environment = "${var.tagenv}"
  }
}

resource "aws_instance" "web-instance" {
  ami                   = "${var.instance_ami}"
  count                 = "${var.ec2_num}"
  instance_type         = "${var.instance_group}"
  key_name              = "${var.ami_key_pair}"
 # subnet_id             = "${element(aws_subnet.red.*.id, count.index)}"
  security_groups       = ["${aws_security_group.sg-web.id}"]

tags = "${merge(
     local.common_tags,
     map(
     "Name", "instance-${element(var.instance_name, count.index)}"))}"
  }

resource "aws_security_group" "sg-web" {
  vpc_id                = "aws_vpc.vpc_base.id"

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

