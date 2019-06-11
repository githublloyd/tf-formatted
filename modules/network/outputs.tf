output "sg-web" {
  value = "${aws_security_group.sg-web.id}"
}
output "vpc_id" {
  value = "${aws_vpc.vpc_base.id}"
}
output "sn-red" {
  value = "${aws_subnet.red.*.id}"
}

