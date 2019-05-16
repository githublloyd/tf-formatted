module "network" {
  source = "../../modules/network/main-ntwrk.tf"
  
  cidr = "${var.cidr}"
  red_cidr = "${var.red_cidr}"
  red_az = "${red_az}"
  amber_cidr = "${var.amber_cidr}"
  amber_az = "${amber_az}"
  green_cidr = "${var.green_cidr}"
  green_az = "${green_az}"
  dns = "${var.dns}"
  dnsh = "${var.dnsh}"
}
