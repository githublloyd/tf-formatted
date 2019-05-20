module "network" {
  source = "../modules/network/"
  
  cidr = "10.0.0.0/16"
  red_cidr = "10.0.0.0/24"
    amber_cidr = "10.0.1.0/24"
  az_irl = "eu-west-1a"
  green_cidr = "10.0.2.0/24"
  dns = "false"
  dnsh = "false"
}
