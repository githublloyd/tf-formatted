resource "aws_vpc" "vpc-base" {
  cidr_block            = "${var.cidr}"
  enable_dns_support    = "${var.dns}"
  enable_dns_hostnames  = "${var.dnsh}"
}

resource "aws_subnet" "red" {
  vpc_id                = "${aws_vpc.vpc-base.id}"
  cidr_block            = "${var.red_cidr}"
  availability_zone     = "${var.red_az}"
}

resource "aws_subnet" "amber" {
  vpc_id                = "${aws_vpc.vpc-base.id}"
  cidr_block            = "${var.amber_cidr}"
  availability_zone     = "${var.amber_az}"
}
resource "aws_subnet" "green" {
  vpc_id                = "${aws_vpc.vpc-base.id}"
  cidr_block            = "${var.green_cidr}"
  availability_zone     = "${var.green_az}"
}