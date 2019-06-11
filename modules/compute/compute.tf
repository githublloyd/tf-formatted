
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
  vpc_security_group_ids= ["${var.security_group}"]
  associate_public_ip_address = "${var.assoc_public_ip}"
  subnet_id             = "${element(var.subnet_id, count.index)}"


  tags = "${merge(
     local.common_tags,
     map(
     "Name", "instance-${element(var.instance_name, count.index)}"))}"
  }

resource "aws_lb_target_group_attachment" "test" {
  count             = "${var.target_group_arn == "" ? 0 : var.ec2_num}"
  target_group_arn = "${var.target_group_arn}"
  target_id        = "${element(aws_instance.web-instance.*.id, count.index)}"
  port             = 80
}