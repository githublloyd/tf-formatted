variable "tagname" {
    type = "string"
    default = "obrienl"
}
variable "tagenv" {
    type = "string"
    default = "dev"
}
variable "tagmod" {
    type = "string"
  default = "module/network"
}
variable "cidr" {
    
}
variable "instance_tenancy" {

}
variable "dns" {

}
variable "dnsh" {

}
variable "az_num" {

}
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
variable "eip" {
    type = "list"
}
variable "nat_dest_cidr" {

}
variable "pub_ip_on_launch" {

}
variable "igw_dest_cidr" {
  
}
