module "network" {
  source = "../../modules/network/main.tf"
  
  cidr = "${var.cidr}"
  red_cidr = "${var.red_cidr}"
  amber_cidr = "${var.amber_cidr}"
  green_cidr = "${var.green_cidr}"
}
