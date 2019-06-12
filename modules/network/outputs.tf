output "sg-web" {
  value = "${aws_security_group.sg-web.id}"
}
output "sg-alb" {
  value = "${aws_security_group.sg-alb.id}"
}
output "vpc_id" {
  value = "${aws_vpc.vpc_base.id}"
}
output "dmz" {
  value = "${aws_subnet.red.*.id}"
}
output "lb-trgt-grp-arn" {
  value = "${aws_lb_target_group.lb-tg-web.arn}"
}
