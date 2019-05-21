variable "cidr" {}
variable "instance_tenancy" {}
variable "dns" {}
variable "dnsh" {}
variable "az_num" {}
variable "red_cidr" {
    type = "list"
}
variable "amber_cidr" {
    type = "list"
}
variable "green_cidr" {
    type = "list"
}
variable "az_irl" {
    type = "list"
}
variable "eip" {}


