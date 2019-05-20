output "vpc_id" {
  value = "${aws_vpc.vpc-base.id}"
}
output "red_subnet" {
  value = ["${aws_subnet.red.*.id}"]
}
output "amber_subnet" {
  value = ["${aws_subnet.amber.*.id}"]
}
