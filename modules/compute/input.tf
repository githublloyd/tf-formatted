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
  default = "module/compute"
}
variable "instance_name" {
    type = "list"
}
variable "instance_ami" {

}
variable "ec2_num" {

}
variable "instance_group" {

}

variable "assoc_public_ip" {
  
}
variable "ami_key" {
  
}
variable "security_group" {
  
}
variable "subnet_id" {
  type = "list"
}
variable "trgt_grp_arn" {
  
}
