
  

module "network" {
  source            = "../modules/network/"
  
# az_num, az_irl and each *colour*_cidr need to be the same amount

  az_num            = 3
  az_irl            = ["eu-west-1a","eu-west-1b","eu-west-1c"]

  cidr              = "10.0.0.0/16"

  instance_tenancy  = "default"
  
  red_cidr          = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  amber_cidr        = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
  green_cidr        = ["10.0.7.0/24","10.0.8.0/24","10.0.9.0/24"]
  dns               = "true"
  dnsh              = "true"
  eip               = "default"
  nat_dest_cidr     = "0.0.0.0/0"
}

module "compute" {
  source = "../modules/compute/"

# instance_name and ec2_num need to be the same amount

  ec2_num            = "2"
  instance_name      = ["web-001","web-002"]
  instance_ami       = "ami-6e28b517"
  instance_group     = "t2.medium"
  ami_key_pair       = "lloydaxe.ppk"
  
}
