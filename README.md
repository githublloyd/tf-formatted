# Terraform

## Terraform Multi Environment Setup using Modules

### The benefits of using a Module-based Terraform code struture
 
> Envrionments are composed of a selection of modules <br>
> Make changes to one environment without affecting another, limiting blast radius <br>
> Each environment has its own .tfstate file <br>

### This Terraform code structure is based on a "Terramod" setup.

It is broken down into 3 main sections per environment;

1. Network (VPC, AZs, subnets, routing and gateways, bastion host) <br>
2. Compute (EC2, security groups) <br>
3. Database (RDS, security groups) <br>
