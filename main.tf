module "dev" {
  source = "dev/"
}

terraform {
  backend "s3" {
    bucket      = "lloydob-v1bucket"
    key         = "terraform.tfstate"
    region         = "eu-west-1"
    encrypt = true
  }
}