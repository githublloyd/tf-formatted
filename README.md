# Terraform

## Terraform Multi Environment Setup using Modules

### The benefits of using a Module-based Terraform code struture
 
1. Envrionments are composed of a selection of modules <br>
2. Make changes to one environment without affecting another, limiting blast radius <br>
3. Each environment has its own .tfstate file <br>

### This Terraform code structure is based on a "Terramod" setup

It is broken down into 3 main sections per environment (dev, stg, prd);

1. Network (VPC, AZs, Subnets, Routing and Gateways, Security Groups) <br>
2. Compute (EC2, ALB) <br>
3. Database (empty for now) <br>

### This Terraform repository uses remote state

- https://www.terraform.io/docs/backends/types/s3.html

The init.tf files in each environment folder calls the .tfstate file from a remote AWS S3 bucket. This pulls from S3, checking the remote state, providers, and modules to .terraform. This can be treated as a temporary .tfstate file.

Please ensure the following;

- [x] S3 bucket isn't publicly available
- [x] Access Key ID and Secret Access Keys are not hardcoded/uploaded
- [x] .gitignore contains the sufficient files