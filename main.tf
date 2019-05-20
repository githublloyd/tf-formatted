module "dev" {
source = "dev/terraform.tf"
}

module "stg" {
source = "stg/terraform.tf"
}

module "prd" {
source = "prd/terraform.tf"
}