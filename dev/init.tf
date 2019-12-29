terraform {
  backend "s3" {
    bucket      = "BUCKETNAME"
    key         = "dev/terraform.tfstate"
    region         = "eu-west-1"
    encrypt = true
  }
}
