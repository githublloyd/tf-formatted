
### Common tags for all network resources ###

locals {
  common_tags = {
    Component = "${var.tagmod}"
    Environment = "${var.tagenv}"
  }
}

resource "aws_ec2" "XXXXXX-instance-XXXXXX" {
  ami                   = "${var.instance_ami}"
  count                 = "${var.ec2_num}"
  instance_type         = "${var.instance_group}"
  key_name              = "${var.ami_key_pair}"
  security_groups       = ["${aws_security_group.XXXXXXXXXXXXXXX.id}"]
    tags = "${merge(
     local.common_tags,
     map(
     "Name", "instance-${var.tagenv}-operating-system-var"))}"
  }
