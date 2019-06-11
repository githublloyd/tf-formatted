terraform {
  backend "s3" {
    bucket      = "lloydob-v1bucket"
    key         = "dev/terraform.tfstate"
    region         = "eu-west-1"
    encrypt = true
  }
}