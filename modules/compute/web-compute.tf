
### Common tags for all network resources ###

locals {
  common_tags   = {
    Component   = "${var.tagmod}"
    Environment = "${var.tagenv}"
  }
}

resource "aws_instance" "web-instance" {
  ami                   = "${var.instance_ami}"
  count                 = "${var.ec2_num}"
  instance_type         = "${var.instance_group}"
  key_name              = "${var.ami_key}"
  vpc_security_group_ids= ["${module.network.sg-web}"]
  associate_public_ip_address = "${var.assoc_public_ip}"

  subnet_id             = "${module}"

  tags = "${merge(
     local.common_tags,
     map(
     "Name", "instance-${element(var.instance_name, count.index)}"))}"
  }


