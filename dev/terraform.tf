module "network" {
  source            = "../modules/network/"
  
  cidr              = "10.0.0.0/16"
  instance_tenancy  = "default"
  dns               = "true"
  dnsh              = "true"
  az_num            = 3
  az_irl            = ["eu-west-1a","eu-west-1b","eu-west-1c"]
  red_cidr          = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  amber_cidr        = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
  green_cidr        = ["10.0.7.0/24","10.0.8.0/24","10.0.9.0/24"]
  pub_ip_on_launch  = "true"
  eip               = "default"
  igw_dest_cidr     = "0.0.0.0/0"
  nat_dest_cidr     = "0.0.0.0/0"

}



module "compute" {
  source             = "../modules/compute/"

  instance_ami       = "ami-6e28b517"
  ec2_num            = "3"
  instance_group     = "t2.medium"
  ami_key            = "lloydaxe"
  instance_name      = ["web-001","web-002","web-003"]
  security_group     = "${module.network.sg-web}"
  assoc_public_ip    = "true"
  subnet_id          = ["${module.network.sn-red}"]
  target_group_arn = "${element(module.alb.target_group_arns, 0)}"

}


module "alb" {
  source                        = "terraform-aws-modules/alb/aws"
  load_balancer_name            = "my-alb"
  security_groups               = ["${module.network.sg-web}"]
  subnets                       = ["${module.network.sn-red}"]
  tags                          = "${map("Environment", "test")}"
  vpc_id                        = "${module.network.vpc_id}"
  http_tcp_listeners            = "${list(map("port", "80", "protocol", "HTTP"))}"
  http_tcp_listeners_count      = "1"
  target_groups                 = "${list(map("name", "web-tg", "backend_protocol", "HTTP", "backend_port", "80"))}"
  target_groups_count           = "1"
  logging_enabled               = "false"
  
}